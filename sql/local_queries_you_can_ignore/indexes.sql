CREATE INDEX idx_clean_orders_created_ts
    ON clean.orders (order_created_ts);

CREATE INDEX idx_clean_orders_is_shipped
    ON clean.orders (is_shipped);