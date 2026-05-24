WITH monthly_product_revenue AS (
    SELECT 
        EXTRACT(MONTH FROM o.order_purchase_timestamp) AS purchase_month,
        oi.product_id,
        SUM(oi.price) AS total_revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status != 'canceled' -- Filtering out canceled orders
    GROUP BY purchase_month, oi.product_id
),
ranked_products AS (
    SELECT 
        purchase_month,
        product_id,
        total_revenue,
        DENSE_RANK() OVER (PARTITION BY purchase_month ORDER BY total_revenue DESC) AS revenue_rank
    FROM monthly_product_revenue
)
SELECT * FROM ranked_products 
WHERE revenue_rank <= 3
ORDER BY purchase_month, revenue_rank;