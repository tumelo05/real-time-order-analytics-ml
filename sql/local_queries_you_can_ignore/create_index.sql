CREATE INDEX idx_raw_orders_order_id
    ON raw.orders_line_items (order_id);

CREATE INDEX idx_raw_orders_order_date
    ON raw.orders_line_items (order_date);