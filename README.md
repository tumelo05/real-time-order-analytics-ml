# 🚀 Real-Time Order Analytics & ML Pipeline

## 📚 Table of Contents

- [Overview](#-overview)
- [Business Problem](#-business-problem)
- [Solution](#-solution)
- [What This System Does](#-what-this-system-does)
- [Why This Matters](#-why-this-matters)
- [End-to-End Capability](#-end-to-end-capability)
- [Architecture](#-architecture)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Data Flow](#-data-flow)
- [Machine Learning Logic](#-machine-learning-logic)
- [Example Output](#-example-output)
- [Setup Instructions](#️-setup-instructions)
- [Key Features](#-key-features)
- [Key Concepts Demonstrated](#-key-concepts-demonstrated)
- [Challenges Solved](#-challenges-solved)
- [Requirements](#-requirementstxt)
- [Future Improvements](#-future-improvements)
- [Conclusion](#-conclusion)
- [Author](#-author)

---

## 📌 Overview

This project implements a **production-grade real-time data pipeline** for processing order events, computing features, and generating **live machine learning predictions** using modern data engineering tools.

The system ingests streaming data from Kafka, processes it in real-time using Apache Spark, and persists enriched data into PostgreSQL.

---

## 🎯 Business Problem

In modern e-commerce and logistics systems, businesses must:

- Monitor order processing in real-time
- Detect delays instantly
- Respond proactively to operational issues
- Improve customer satisfaction

### ❗ Challenge

Traditional batch systems:
- Process data too late ⏳
- Cannot detect issues in real-time ❌

---

## ✅ Solution

We built a **real-time streaming analytics system** that:

✅ Tracks incoming orders instantly  
✅ Computes processing delays in real-time  
✅ Classifies delivery risk dynamically  
✅ Stores results for analytics and dashboards  

---

## 🧠 What This System Does

For every incoming order:

1. 📡 Event is produced → Kafka  
2. ⚡ Spark reads the event stream  
3. 📊 Features are computed:
   - processing_delay_sec  
4. 🤖 ML logic predicts:
   - NORMAL  
   - WARNING  
   - DELAYED  
5. 🗄 Data is stored in PostgreSQL  

---
### 🏆 Why This Matters

In industries such as:

- E-commerce  
- Logistics  
- Fintech  
- Ride-hailing  

Real-time data processing is essential for:

- Customer experience optimization  
- Operational monitoring  
- Risk detection  
- Decision automation  

---

### 🚀 End-to-End Capability

This project delivers a complete pipeline:

## 🏗️ Architecture
Kafka Producer → Kafka Topic → Spark Streaming → PostgreSQL
↓
Feature Engineering
↓
ML Classification

./figures/streaming-output.png

---

## ⚙️ Tech Stack

| Component | Technology |
|----------|----------|
| Streaming | Apache Kafka |
| Processing | Apache Spark (Structured Streaming) |
| Database | PostgreSQL |
| Orchestration | Docker Compose |
| Language | Python |
| ML Logic | Rule-based classification |

---

## 📂 Project Structure


orders-analytics-ml/
│
├── kafka/                 # Kafka producer scripts
├── spark/
│   └── streaming/         # Spark streaming jobs
├── sql/                   # Database schema
├── data/                  # Raw / generated data
├── notebooks/             # Exploratory work
├── src/                   #loading script
├── figures/               # Screenshots & diagrams
├── docker-compose.yml
└── README.md

---


## 🧾 SQL Scripts

Database setup and analytics queries are available in the `sql/` directory:

- Schema creation
- Table definitions
- Schema evolution (ML columns)
- Analytical queries

The SQL layer reflects real-world data engineering practices, including:

- Incremental schema evolution for streaming pipelines  
- Structured table design for ingestion and analytics  
- Query patterns for real-time monitoring and reporting  

Key files include:

- `01_create_schema.sql` → Creates database schema  
- `02_create_orders_table.sql` → Defines core orders table  
- `03_alter_add_ml_columns.sql` → Adds ML-related columns  
- `04_sample_queries.sql` → Analytical queries for insights  

---

## 📓 Notebooks

Exploratory analysis and feature validation are included in the `notebooks/` directory:

- Data exploration and profiling
- Feature engineering validation
- Delay distribution analysis

These notebooks demonstrate the analytical layer behind the streaming pipelines

---


## 🔄 Data Flow

1. Kafka Producer emits events:

```json
{
  "event_type": "order_created",
  "event_ts": "2026-05-18T10:31:21Z",
  "order_id": "order_57739",
  "total_items": 1
}
```



Spark transforms data:


Parses JSON
Computes features
Applies ML classification



Postgres stores enriched data:
order_id | processing_delay_sec | delay_risk
------------------------------------------------
order_57739 | 1 | NORMAL
order_44458 | 8 | WARNING
order_28956 | 20 | DELAYED


---

## 🤖 Machine Learning Logic
A simple real-time classification model:
Delay (sec)Risk< 5NORMAL ✅5–15WARNING ⚠️> 15DELAYED 🔴

📸 Example Output
./figures/kafka-spark-postgres.png ✅

---

## 🛠️ Setup Instructions
1. Clone Repository
```git clone https://github.com/tumelo05/orders-analytics-ml.gitcd orders-analytics-mlShow more lines```

2. Start Services
```docker compose up -d```

3. Create Kafka Topic
```docker exec -it order_analytics_kafka kafka-topics \  --bootstrap-server localhost:9092 \  --create \  --topic orders.created \  --partitions 3 \  --replication-factor 1```

4. Run Kafka Producer
```docker exec -it order_analytics_kafka bashpython3 /opt/order_event_producer.py```

5. Run Spark Job
```docker exec -it order_analytics_spark bash/opt/spark/bin/spark-submit \  --packages org.apache.spark:spark-sql-kafka-0-10_2.12:3.5.0 \  --conf spark.jars.ivy=/tmp/ivy \  /opt/spark_job.py```

6. Verify in Postgres
```
docker exec -it order_analytics_postgres psql \  -U analytics_user -d order_analytics
SELECT *
FROM raw.orders_line_items
WHERE prod_sku = 'STREAM_SKU'
ORDER BY rec_id DESC
LIMIT 10;
```
---

## 📊 Key Features
✅ Real-time ingestion
✅ Streaming transformations
✅ Feature engineering
✅ Live ML predictions
✅ Hybrid architecture (batch + streaming)

---
## 🔥 Key Concepts Demonstrated

Event-driven architecture
Stream processing
Micro-batch execution
Schema evolution
Real-time analytics
ML inference in streaming

---

## ⚠️ Challenges Solved
Problem	Solution
Kafka container crashes	Restart & debug
Missing topics	Manual creation
Dependency issues	Install required Python packages
Schema mismatches	DB migrations
Streaming failures	Debug Spark logs


---

📦 requirements.txt
```
pyspark==3.5.0
kafka-python
psycopg2-binary
```
---
## 🚀 Future Improvements

✅ Replace rules with ML model (e.g. Logistic Regression)
✅ Add real-time dashboards (Power BI / Superset)
✅ Add Airflow for orchestration
✅ Implement alerting system
✅ Deploy to cloud (AWS / Azure)

---

## 🏁 Conclusion
This project demonstrates how to build a real-time data processing and ML pipeline, solving a real business problem using production-grade tools.

---
## 👤 Author
Tumelo Sethosa
Contact: tumelo.j.sethosa@gmail.com
---
⭐ If you like this project
Give it a star ⭐
