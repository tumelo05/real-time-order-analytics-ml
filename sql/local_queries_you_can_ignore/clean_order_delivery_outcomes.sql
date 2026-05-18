CREATE TABLE clean.order_delivery_outcomes (
    order_id               TEXT PRIMARY KEY
                             REFERENCES clean.orders(order_id),
    delivery_minutes        INTEGER,
    is_delayed              BOOLEAN NOT NULL,
    delay_threshold_minutes INTEGER NOT NULL DEFAULT 1440,
    evaluated_at            TIMESTAMPTZ DEFAULT NOW()
);