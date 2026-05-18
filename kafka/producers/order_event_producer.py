import json
import time
import random
from datetime import datetime, timezone
from kafka import KafkaProducer

# =========================
# Kafka configuration
# =========================
producer = KafkaProducer(
    bootstrap_servers="order_analytics_kafka:29092",
    key_serializer=lambda k: k.encode("utf-8"),
    value_serializer=lambda v: json.dumps(v).encode("utf-8"),
    linger_ms=10
)

ORDERS_CREATED_TOPIC = "orders.created"

print("Producing stream events...")

# =========================
# Generate streaming events
# =========================
while True:

    order_id = f"order_{random.randint(1, 100000)}"

    event = {
        "event_type": "order_created",
        "event_ts": datetime.now(timezone.utc).isoformat(),
        "order_id": order_id,
        "order_date": datetime.now(timezone.utc).isoformat(),
        "total_items": random.randint(1, 5)
    }

    producer.send(
        ORDERS_CREATED_TOPIC,
        key=order_id,
        value=event
    )

    print("✅ Sent:", event)

    time.sleep(1)