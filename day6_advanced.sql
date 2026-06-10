USE olist_ecommerce;

SELECT 
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
    ROUND(SUM(op.payment_value), 2) AS monthly_revenue,
    ROUND(SUM(SUM(op.payment_value)) OVER (
        ORDER BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
    ), 2) AS running_total
FROM orders o
JOIN order_payments op ON o.order_id = op.order_id
WHERE o.order_status = 'delivered'
GROUP BY month
ORDER BY month;

WITH monthly_revenue AS (
    SELECT 
        DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
        ROUND(SUM(op.payment_value), 2) AS revenue
    FROM orders o
    JOIN order_payments op ON o.order_id = op.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY month
)
SELECT 
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY month) AS prev_month_revenue,
    ROUND((revenue - LAG(revenue) OVER (ORDER BY month)) 
          / LAG(revenue) OVER (ORDER BY month) * 100, 2) AS growth_pct
FROM monthly_revenue
ORDER BY month;

WITH seller_revenue AS (
    SELECT 
        s.seller_id,
        s.seller_state,
        s.seller_city,
        ROUND(SUM(op.payment_value), 2) AS total_revenue,
        COUNT(DISTINCT oi.order_id) AS total_orders
    FROM sellers s
    JOIN order_items oi ON s.seller_id = oi.seller_id
    JOIN order_payments op ON oi.order_id = op.order_id
    GROUP BY s.seller_id, s.seller_state, s.seller_city
)
SELECT 
    seller_id,
    seller_state,
    seller_city,
    total_revenue,
    total_orders,
    RANK() OVER (PARTITION BY seller_state ORDER BY total_revenue DESC) AS rank_in_state,
    ROUND(total_revenue / SUM(total_revenue) OVER (PARTITION BY seller_state) * 100, 2) AS pct_of_state_revenue
FROM seller_revenue
ORDER BY seller_state, rank_in_state
LIMIT 30;

WITH product_revenue AS (
    SELECT 
        p.product_id,
        p.product_category_name,
        ROUND(SUM(op.payment_value), 2) AS total_revenue,
        COUNT(DISTINCT oi.order_id) AS total_orders,
        ROUND(AVG(r.review_score), 2) AS avg_review
    FROM products p
    JOIN order_items oi ON p.product_id = oi.product_id
    JOIN order_payments op ON oi.order_id = op.order_id
    JOIN order_reviews r ON oi.order_id = r.order_id
    GROUP BY p.product_id, p.product_category_name
),
ranked AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY product_category_name 
            ORDER BY total_revenue DESC
        ) AS row_num
    FROM product_revenue
)
SELECT 
    product_category_name,
    product_id,
    total_revenue,
    total_orders,
    avg_review,
    row_num
FROM ranked
WHERE row_num = 1
ORDER BY total_revenue DESC
LIMIT 15;

WITH monthly_revenue AS (
    SELECT 
        DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
        ROUND(SUM(op.payment_value), 2) AS revenue
    FROM orders o
    JOIN order_payments op ON o.order_id = op.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY month
)
SELECT 
    month,
    revenue,
    ROUND(AVG(revenue) OVER (
        ORDER BY month
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS rolling_3month_avg,
    ROUND(MAX(revenue) OVER (
        ORDER BY month
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS rolling_3month_max,
    ROUND(MIN(revenue) OVER (
        ORDER BY month
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS rolling_3month_min
FROM monthly_revenue
ORDER BY month;