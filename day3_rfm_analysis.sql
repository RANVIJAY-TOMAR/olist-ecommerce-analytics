USE olist_ecommerce;

SELECT 
    c.customer_unique_id,
    MAX(o.order_purchase_timestamp) AS last_purchase_date,
    COUNT(DISTINCT o.order_id) AS frequency,
    ROUND(SUM(op.payment_value), 2) AS monetary
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_payments op ON o.order_id = op.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id
ORDER BY monetary DESC
LIMIT 20;

WITH rfm_base AS (
    SELECT 
        c.customer_unique_id,
        DATEDIFF('2018-10-01', MAX(o.order_purchase_timestamp)) AS recency,
        COUNT(DISTINCT o.order_id) AS frequency,
        ROUND(SUM(op.payment_value), 2) AS monetary
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_payments op ON o.order_id = op.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
),
rfm_scores AS (
    SELECT *,
        NTILE(5) OVER (ORDER BY recency DESC) AS r_score,
        NTILE(5) OVER (ORDER BY frequency ASC) AS f_score,
        NTILE(5) OVER (ORDER BY monetary ASC) AS m_score
    FROM rfm_base
),
rfm_segments AS (
    SELECT *,
        CONCAT(r_score, f_score, m_score) AS rfm_cell,
        (r_score + f_score + m_score) AS rfm_total,
        CASE
            WHEN r_score >= 4 AND f_score >= 4 THEN 'Champion'
            WHEN r_score >= 3 AND f_score >= 3 THEN 'Loyal Customer'
            WHEN r_score >= 4 AND f_score < 2 THEN 'New Customer'
            WHEN r_score < 2 AND f_score >= 3 THEN 'At Risk'
            WHEN r_score < 2 AND f_score < 2 THEN 'Lost'
            ELSE 'Potential Loyal'
        END AS segment
    FROM rfm_scores
)
SELECT 
    segment,
    COUNT(*) AS customer_count,
    ROUND(AVG(recency), 0) AS avg_recency_days,
    ROUND(AVG(frequency), 1) AS avg_frequency,
    ROUND(AVG(monetary), 2) AS avg_monetary,
    ROUND(SUM(monetary), 2) AS total_revenue
FROM rfm_segments
GROUP BY segment
ORDER BY total_revenue DESC;

WITH customer_orders AS (
    SELECT 
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        MIN(o.order_purchase_timestamp) AS first_order,
        MAX(o.order_purchase_timestamp) AS last_order,
        DATEDIFF(MAX(o.order_purchase_timestamp), 
                 MIN(o.order_purchase_timestamp)) AS customer_lifespan_days
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT
    CASE 
        WHEN total_orders = 1 THEN 'One-time buyer'
        WHEN total_orders BETWEEN 2 AND 3 THEN 'Occasional buyer'
        WHEN total_orders BETWEEN 4 AND 6 THEN 'Regular buyer'
        WHEN total_orders > 6 THEN 'Frequent buyer'
    END AS buyer_type,
    COUNT(*) AS customer_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage,
    ROUND(AVG(customer_lifespan_days), 0) AS avg_lifespan_days
FROM customer_orders
GROUP BY buyer_type
ORDER BY customer_count DESC;
