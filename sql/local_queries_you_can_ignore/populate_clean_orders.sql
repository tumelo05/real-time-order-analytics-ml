INSERT INTO clean.orders (
    order_id,
    order_created_ts,
    order_shipped_ts,
    total_items,
    distinct_skus,
    delivery_time_minutes,
    is_shipped
)
SELECT
    order_id,
    MIN(order_date) AS order_created_ts,
    MAX(shipped_at) AS order_shipped_ts,
    COALESCE(SUM(prod_qty), 0) AS total_items,
    COUNT(DISTINCT prod_sku) AS distinct_skus,
    CASE
        WHEN MAX(shipped_at) IS NOT NULL THEN
            EXTRACT(EPOCH FROM (MAX(shipped_at) - MIN(order_date))) / 60
        ELSE NULL
    END AS delivery_time_minutes,
    CASE
        WHEN MAX(shipped_at) IS NOT NULL THEN TRUE
        ELSE FALSE
    END AS is_shipped
FROM raw.orders_line_items
GROUP BY order_id;