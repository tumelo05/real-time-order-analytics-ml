CREATE TABLE raw.orders_line_items (
    rec_id       BIGINT PRIMARY KEY,
    order_id     TEXT NOT NULL,
    order_date   TIMESTAMPTZ NOT NULL,
    shipped_at   TIMESTAMPTZ,
    prod_sku     TEXT,              -- ✅ nullable in raw
    prod_qty     INTEGER,           -- ✅ allow 0 / NULL in raw
    ingested_at  TIMESTAMPTZ DEFAULT NOW()
);
``