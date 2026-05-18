CREATE TABLE features.order_features (
    order_id TEXT PRIMARY KEY
        REFERENCES clean.orders(order_id),

    -- Temporal
    order_hour SMALLINT NOT NULL,
    order_day_of_week SMALLINT NOT NULL CHECK (order_day_of_week BETWEEN 0 AND 6),
    is_weekend BOOLEAN NOT NULL,

    -- Order composition
    total_items INTEGER NOT NULL,
    distinct_skus INTEGER NOT NULL,

    -- Historical performance
    avg_delivery_time_last_7_days NUMERIC(10,2),
    avg_delivery_time_last_30_days NUMERIC(10,2),
    delay_rate_last_30_days NUMERIC(5,4),

    -- Operational load
    orders_created_last_24h INTEGER,
    orders_created_same_hour_last_7d INTEGER,

    feature_created_at TIMESTAMPTZ DEFAULT NOW()
);