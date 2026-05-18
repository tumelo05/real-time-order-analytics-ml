CREATE TABLE clean.orders (
    order_id              TEXT PRIMARY KEY,
    order_created_ts      TIMESTAMPTZ NOT NULL,
    order_shipped_ts      TIMESTAMPTZ,
    total_items           INTEGER NOT NULL,
    distinct_skus         INTEGER NOT NULL,
    delivery_time_minutes INTEGER,
    is_shipped            BOOLEAN NOT NULL,
    created_at            TIMESTAMPTZ DEFAULT NOW()
);
