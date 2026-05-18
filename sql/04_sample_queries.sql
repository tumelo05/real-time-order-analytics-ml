-- Latest streaming records
SELECT *
FROM raw.orders_line_items
WHERE prod_sku = 'STREAM_SKU'
ORDER BY rec_id DESC
LIMIT 10;

-- Distribution of delay risk
SELECT delay_risk, COUNT(*)
FROM raw.orders_line_items
WHERE prod_sku = 'STREAM_SKU'
GROUP BY delay_risk;

-- Average processing delay
SELECT AVG(processing_delay_sec)
FROM raw.orders_line_items
WHERE prod_sku = 'STREAM_SKU';

-- Orders per minute (real-time aggregation)
SELECT date_trunc('minute', created_ts) AS minute,
       COUNT(*) AS order_count
FROM raw.orders_line_items
WHERE prod_sku = 'STREAM_SKU'
GROUP BY minute
ORDER BY minute DESC;