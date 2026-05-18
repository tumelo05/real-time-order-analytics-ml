🚀 Real-Time Order Analytics & ML Pipeline
📚 Table of Contents
Overview
Business Problem
Solution
What This System Does
Why This Matters
End-to-End Capability
Architecture
Tech Stack
Project Structure
Data Flow
Machine Learning Logic
Example Output
Setup Instructions
Key Features
Key Concepts Demonstrated
Challenges Solved
Requirements
Future Improvements
Conclusion
Author
📌 Overview

This project implements a production-grade real-time data pipeline for processing order events, computing features, and generating live machine learning predictions using modern data engineering tools.

The system ingests streaming data from Kafka, processes it in real-time using Apache Spark, and persists enriched data into PostgreSQL.

🎯 Business Problem

Modern e-commerce and logistics systems must:

Monitor order processing in real time
Detect delays instantly
Respond proactively to operational issues
Improve customer satisfaction
❗ Challenge

Traditional batch systems:

Process data too late ⏳
Cannot detect issues in real time ❌
✅ Solution

We built a real-time streaming analytics system that:

Tracks incoming orders instantly
Computes processing delays in real time
Classifies delivery risk dynamically
Stores results for analytics and dashboards
🧠 What This System Does

For every incoming order:

Event is produced → Kafka
Spark reads the event stream
Features are computed
processing_delay_sec
ML logic predicts:
NORMAL
WARNING
DELAYED
Data is stored in PostgreSQL
🏆 Why This Matters

Used in industries such as:

E-commerce
Logistics
Fintech
Ride-hailing

This enables:

Customer experience optimization
Operational monitoring
Risk detection
Decision automation
🚀 End-to-End Capability

Kafka Producer → Kafka Topic → Spark Streaming → Feature Engineering → ML Classification → PostgreSQL

Kafka Producer
      ↓
Kafka Topic
      ↓
Spark Streaming
      ↓
Feature Engineering
      ↓
ML Classification
      ↓
PostgreSQL
🏗️ Architecture
Kafka Producer → Kafka Topic → Spark Streaming → PostgreSQL

⚙️ Tech Stack
Component	Technology
Streaming	Apache Kafka
Processing	Apache Spark (Structured Streaming)
Database	PostgreSQL
Orchestration	Docker Compose
Language	Python
ML Logic	Rule-based classification
📂 Project Structure
orders-analytics-ml/
│
├── kafka/                 # Kafka producer scripts
├── spark/
│   └── streaming/         # Spark streaming jobs
├── sql/                   # Database schema
├── data/                  # Raw / generated data
├── notebooks/             # Exploratory work
├── src/                   # Loading scripts
├── figures/               # Screenshots & diagrams
├── docker-compose.yml
└── README.md
🔄 Data Flow
1. Kafka Producer emits events
{
  "event_type": "order_created",
  "event_ts": "2026-05-18T10:31:21Z",
  "order_id": "order_57739",
  "total_items": 1
}
2. Spark Streaming
Parses JSON
Computes features
Applies ML classification
3. ML Logic
Processing Delay (sec)	Risk Level
< 5	NORMAL ✅
5 – 15	WARNING ⚠️
> 15	DELAYED 🔴
4. PostgreSQL Output
order_id     | processing_delay_sec | delay_risk
-------------|----------------------|-----------
order_57739  | 1                    | NORMAL
order_44458  | 8                    | WARNING
order_28956  | 20                   | DELAYED
🧾 SQL Scripts

Located in sql/:

01_create_schema.sql → Schema setup
02_create_orders_table.sql → Table definition
03_alter_add_ml_columns.sql → ML columns
04_sample_queries.sql → Analytics queries
📓 Notebooks
Data exploration
Feature validation
Delay distribution analysis
🛠️ Setup Instructions
1. Clone Repository
git clone https://github.com/tumelo05/orders-analytics-ml.git
cd orders-analytics-ml
2. Start Services
docker compose up -d
3. Create Kafka Topic
docker exec -it order_analytics_kafka kafka-topics \
  --bootstrap-server localhost:9092 \
  --create \
  --topic orders.created \
  --partitions 3 \
  --replication-factor 1
4. Run Kafka Producer
docker exec -it order_analytics_kafka bash
python3 /opt/order_event_producer.py
5. Run Spark Job
docker exec -it order_analytics_spark bash
/opt/spark/bin/spark-submit \
  --packages org.apache.spark:spark-sql-kafka-0-10_2.12:3.5.0 \
  --conf spark.jars.ivy=/tmp/ivy \
  /opt/spark_job.py
6. Verify in Postgres
SELECT *
FROM raw.orders_line_items
WHERE prod_sku = 'STREAM_SKU'
ORDER BY rec_id DESC
LIMIT 10;
📊 Key Features
Real-time ingestion
Streaming transformations
Feature engineering
Live ML predictions
Hybrid batch + streaming architecture
🔥 Key Concepts Demonstrated
Event-driven architecture
Stream processing
Micro-batch execution
Schema evolution
Real-time analytics
ML inference in streaming
⚠️ Challenges Solved
Problem	Solution
Kafka container crashes	Restart & debugging
Missing topics	Manual topic creation
Dependency issues	Install required packages
Schema mismatches	DB migrations
Streaming failures	Spark log debugging
📦 Requirements
pyspark==3.5.0
kafka-python
psycopg2-binary
🚀 Future Improvements
Replace rule-based ML with real ML model (Logistic Regression)
Add dashboards (Power BI / Superset)
Add Airflow orchestration
Add alerting system
Deploy to AWS / Azure
🏁 Conclusion

This project demonstrates a full real-time data pipeline with streaming, processing, and ML inference using production-grade tools.

👤 Author

Tumelo Sethosa
📧 tumelo.j.sethosa@gmail.com
