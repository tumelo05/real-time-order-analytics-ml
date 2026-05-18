INSERT INTO clean.order_delivery_outcomes (
    order_id,
    delivery_minutes,
    is_delayed,
    delay_threshold_minutes
)
SELECT
    order_id,
    delivery_time_minutes,
    CASE
        WHEN is_shipped = FALSE THEN TRUE
        WHEN delivery_time_minutes > 1440 THEN TRUE
        ELSE FALSE
    END AS is_delayed,
    1440
FROM clean.orders;