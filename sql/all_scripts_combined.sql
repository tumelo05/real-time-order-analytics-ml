-- Create schema for raw data
CREATE SCHEMA IF NOT EXISTS raw;

-- Create main orders table
CREATE TABLE IF NOT EXISTS raw.orders_line_items (
    rec_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id TEXT,
    order_date TIMESTAMP,
    shipped_at TIMESTAMP,
    prod_sku TEXT,
    prod_qty INT,
    ingested_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Add ML-related columns for real-time predictions

ALTER TABLE raw.orders_line_items
ADD COLUMN IF NOT EXISTS processing_delay_sec INT;

ALTER TABLE raw.orders_line_items
ADD COLUMN IF NOT EXISTS delay_risk TEXT;

ALTER TABLE raw.orders_line_items
ADD COLUMN IF NOT EXISTS created_ts TIMESTAMP;

-- Latest streaming records
SELECT *
FROM raw.orders_line_items
WHERE prod_sku = 'STREAM_SKU'
ORDER BY rec_id DESC
LIMIT 10;

-- Distribution of delay risk
SELECT delay_risk, COUNT(*)
FROM raw.orders_line_items
WHERE prod_sku = 'STREAM_SKU'
GROUP BY delay_risk;

-- Average processing delay
SELECT AVG(processing_delay_sec)
FROM raw.orders_line_items
WHERE prod_sku = 'STREAM_SKU';

-- Orders per minute (real-time aggregation)
SELECT date_trunc('minute', created_ts) AS minute,
       COUNT(*) AS order_count
FROM raw.orders_line_items
WHERE prod_sku = 'STREAM_SKU'
GROUP BY minute
ORDER BY minute DESC;

-- Optional cleanup script

TRUNCATE TABLE raw.orders_line_items;

-- Drop table if needed
-- DROP TABLE raw.orders_line_items;