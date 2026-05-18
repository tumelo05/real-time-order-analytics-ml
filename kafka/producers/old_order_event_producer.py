import json
import time
import psycopg2
from kafka import KafkaProducer
from datetime import timezone

# =========================
# Kafka configuration
# =========================
KAFKA_BOOTSTRAP_SERVERS = ["localhost:9092"]
ORDERS_CREATED_TOPIC = "orders.created"
ORDERS_SHIPPED_TOPIC = "orders.shipped"

producer = KafkaProducer(
    bootstrap_servers=KAFKA_BOOTSTRAP_SERVERS,
    key_serializer=lambda k: k.encode("utf-8"),
    value_serializer=lambda v: json.dumps(v).encode("utf-8"),
    linger_ms=10
)

# =========================
# PostgreSQL configuration
# =========================
conn = psycopg2.connect(
    dbname="order_analytics",
    user="analytics_user",
    password="analytics_pwd",
    host="host.docker.internal",
    port="5433"
)

cur = conn.cursor()

# =========================
# Fetch orders
# =========================
cur.execute("""
    SELECT
        order_id,
        order_created_ts,
        order_shipped_ts,
        total_items
    FROM clean.orders
    ORDER BY order_created_ts
""")

orders = cur.fetchall()

print(f"Publishing {len(orders)} orders to Kafka...")

# =========================
# Emit events
# =========================
for order_id, created_ts, shipped_ts, total_items in orders:

    # ---- order_created event ----
    order_created_event = {
        "event_type": "order_created",
        "event_ts": created_ts.astimezone(timezone.utc).isoformat(),
        "order_id": order_id,
        "order_date": created_ts.astimezone(timezone.utc).isoformat(),
        "total_items": total_items
    }

    producer.send(
        ORDERS_CREATED_TOPIC,
        key=order_id,
        value=order_created_event
    )

    # ---- order_shipped event (if shipped) ----
    if shipped_ts is not None:
        order_shipped_event = {
            "event_type": "order_shipped",
            "event_ts": shipped_ts.astimezone(timezone.utc).isoformat(),
            "order_id": order_id,
            "shipped_at": shipped_ts.astimezone(timezone.utc).isoformat()
        }

        producer.send(
            ORDERS_SHIPPED_TOPIC,
            key=order_id,
            value=order_shipped_event
        )

    # ---- Throttle (simulate real stream) ----
    time.sleep(0.01)

producer.flush()
producer.close()
cur.close()
conn.close()

print("Kafka event production completed")