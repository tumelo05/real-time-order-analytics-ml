from pyspark.sql import SparkSession
from pyspark.sql.functions import col, from_json
from pyspark.sql.types import StructType, StringType

# =========================
# Create Spark Session
# =========================
spark = SparkSession.builder \
    .appName("KafkaToPostgresOrders") \
    .getOrCreate()

# =========================
# Kafka config
# =========================
KAFKA_BOOTSTRAP = "order_analytics_kafka:29092"
TOPIC_CREATED = "orders.created"

# =========================
# Define schema (matches producer)
# =========================
schema = StructType() \
    .add("event_type", StringType()) \
    .add("event_ts", StringType()) \
    .add("order_id", StringType()) \
    .add("order_date", StringType()) \
    .add("total_items", StringType())

# =========================
# Read from Kafka
# =========================
df = spark.readStream \
    .format("kafka") \
    .option("kafka.bootstrap.servers", KAFKA_BOOTSTRAP) \
    .option("subscribe", TOPIC_CREATED) \
    .option("startingOffsets", "earliest") \
    .load()

# =========================
# Convert Kafka value to string
# =========================
json_df = df.selectExpr("CAST(value AS STRING)")

# =========================
# Parse JSON
# =========================
parsed_df = json_df.select(
    from_json(col("value"), schema).alias("data")
).select("data.*")

# =========================
# Output to console
# =========================
query = parsed_df.writeStream \
    .format("console") \
    .outputMode("append") \
    .start()

query.awaitTermination()