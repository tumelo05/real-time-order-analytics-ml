INSERT INTO features.order_features (
    order_id,
    order_hour,
    order_day_of_week,
    is_weekend,
    total_items,
    distinct_skus,
    avg_delivery_time_last_7_days,
    avg_delivery_time_last_30_days,
    delay_rate_last_30_days,
    orders_created_last_24h,
    orders_created_same_hour_last_7d
)
SELECT
    o.order_id,

    EXTRACT(HOUR FROM o.order_created_ts)::SMALLINT,
    EXTRACT(DOW FROM o.order_created_ts)::SMALLINT,
    CASE
        WHEN EXTRACT(DOW FROM o.order_created_ts) IN (0, 6) THEN TRUE
        ELSE FALSE
    END,

    o.total_items,
    o.distinct_skus,

    (
        SELECT AVG(o2.delivery_time_minutes)
        FROM clean.orders o2
        WHERE o2.order_created_ts >= o.order_created_ts - INTERVAL '7 days'
          AND o2.order_created_ts <  o.order_created_ts
          AND o2.delivery_time_minutes IS NOT NULL
    ),

    (
        SELECT AVG(o2.delivery_time_minutes)
        FROM clean.orders o2
        WHERE o2.order_created_ts >= o.order_created_ts - INTERVAL '30 days'
          AND o2.order_created_ts <  o.order_created_ts
          AND o2.delivery_time_minutes IS NOT NULL
    ),

    (
        SELECT AVG(
            CASE WHEN odo.is_delayed THEN 1 ELSE 0 END
        )
        FROM clean.orders o2
        JOIN clean.order_delivery_outcomes odo
          ON o2.order_id = odo.order_id
        WHERE o2.order_created_ts >= o.order_created_ts - INTERVAL '30 days'
          AND o2.order_created_ts <  o.order_created_ts
    ),

    (
        SELECT COUNT(*)
        FROM clean.orders o2
        WHERE o2.order_created_ts >= o.order_created_ts - INTERVAL '24 hours'
          AND o2.order_created_ts <  o.order_created_ts
    ),

    (
        SELECT COUNT(*)
        FROM clean.orders o2
        WHERE EXTRACT(HOUR FROM o2.order_created_ts) =
              EXTRACT(HOUR FROM o.order_created_ts)
          AND o2.order_created_ts >= o.order_created_ts - INTERVAL '7 days'
          AND o2.order_created_ts <  o.order_created_ts
    )
FROM clean.orders o;