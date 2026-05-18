from pyspark.sql import SparkSession
from pyspark.sql.functions import col, from_json, current_timestamp, when
from pyspark.sql.types import StructType, StringType
import psycopg2

# =========================
# Spark Session
# =========================
spark = SparkSession.builder \
    .appName("KafkaToPostgresOrders") \
    .getOrCreate()

# =========================
# Kafka Config
# =========================
KAFKA_BOOTSTRAP = "order_analytics_kafka:29092"
TOPIC_CREATED = "orders.created"

# =========================
# Schema
# =========================
schema = StructType() \
    .add("event_type", StringType()) \
    .add("event_ts", StringType()) \
    .add("order_id", StringType()) \
    .add("order_date", StringType()) \
    .add("total_items", StringType())

# =========================
# Read Kafka
# =========================
df = spark.readStream \
    .format("kafka") \
    .option("kafka.bootstrap.servers", KAFKA_BOOTSTRAP) \
    .option("subscribe", TOPIC_CREATED) \
    .option("startingOffsets", "latest") \
    .load()

json_df = df.selectExpr("CAST(value AS STRING)")

parsed_df = json_df.select(
    from_json(col("value"), schema).alias("data")
).select("data.*")

# =========================
# ✅ FEATURE ENGINEERING + ML
# =========================
enriched_df = parsed_df \
    .withColumn(
        "processing_delay_sec",
        (current_timestamp().cast("long") - col("event_ts").cast("timestamp").cast("long"))
    ) \
    .withColumn(
        "delay_risk",
        when(col("processing_delay_sec") < 5, "NORMAL")
        .when((col("processing_delay_sec") >= 5) & (col("processing_delay_sec") < 15), "WARNING")
        .otherwise("DELAYED")
    )

# =========================
# Postgres Config
# =========================
PG_CONN = {
    "dbname": "order_analytics",
    "user": "analytics_user",
    "password": "analytics_pwd",
    "host": "order_analytics_postgres",
    "port": "5432"
}

# =========================
# Write Function
# =========================
def write_to_postgres(batch_df, batch_id):

    count = batch_df.count()
    print(f"🔥 Batch {batch_id} received with {count} rows")

    if count == 0:
        print("⚠️ Empty batch — skipping")
        return

    rows = batch_df.collect()
    print(f"✅ Writing {len(rows)} rows to Postgres...")

    conn = psycopg2.connect(**PG_CONN)
    cur = conn.cursor()

    for row in rows:
        cur.execute("""
            INSERT INTO raw.orders_line_items (
                order_id,
                order_date,
                prod_sku,
                prod_qty,
                shipped_at,
                processing_delay_sec,
                delay_risk,
                created_ts
            )
            VALUES (%s, %s, %s, %s, %s, %s, %s, current_timestamp)
        """, (
            row.order_id,
            row.order_date,
            "STREAM_SKU",
            int(row.total_items),
            None,
            int(row.processing_delay_sec),
            row.delay_risk
        ))

    conn.commit()
    cur.close()
    conn.close()

    print(f"✅ Batch {batch_id} successfully written")

# =========================
# Stream Write
# =========================
query = enriched_df.writeStream \
    .foreachBatch(write_to_postgres) \
    .outputMode("append") \
    .start()

query.awaitTermination()
