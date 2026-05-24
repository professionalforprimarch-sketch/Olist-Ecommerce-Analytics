WITH customer_order_history AS (
    SELECT 
        c.customer_unique_id,
        o.order_purchase_timestamp,
        LAG(o.order_purchase_timestamp) OVER (
            PARTITION BY c.customer_unique_id 
            ORDER BY o.order_purchase_timestamp
        ) AS previous_order_timestamp
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
),
time_gaps AS (
    SELECT 
        customer_unique_id,
        EXTRACT(DAY FROM (order_purchase_timestamp - previous_order_timestamp)) AS days_between_orders
    FROM customer_order_history
    WHERE previous_order_timestamp IS NOT NULL
)
SELECT 
    ROUND(AVG(days_between_orders), 1) AS overall_avg_days_to_return,
    COUNT(customer_unique_id) AS total_repeat_purchases
FROM time_gaps;