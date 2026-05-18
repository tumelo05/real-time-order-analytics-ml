SELECT COUNT(*) FROM raw.orders_line_items;

SELECT COUNT(*)
FROM raw.orders_line_items
WHERE prod_sku IS NULL;

SELECT COUNT(*)
FROM raw.orders_line_items
WHERE prod_qty = 0;
