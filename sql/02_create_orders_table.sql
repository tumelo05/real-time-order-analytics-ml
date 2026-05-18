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