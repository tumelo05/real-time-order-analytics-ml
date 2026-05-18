-- Add ML-related columns for real-time predictions

ALTER TABLE raw.orders_line_items
ADD COLUMN IF NOT EXISTS processing_delay_sec INT;

ALTER TABLE raw.orders_line_items
ADD COLUMN IF NOT EXISTS delay_risk TEXT;

ALTER TABLE raw.orders_line_items
ADD COLUMN IF NOT EXISTS created_ts TIMESTAMP;