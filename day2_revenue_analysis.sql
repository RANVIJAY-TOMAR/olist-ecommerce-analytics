SELECT 
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
    ROUND(SUM(p.payment_value), 2) AS monthly_revenue,
    COUNT(DISTINCT o.order_id) AS monthly_orders
FROM orders o
JOIN order_payments p ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
GROUP BY month
ORDER BY month;

SELECT 
    p.product_category_name,
    ROUND(SUM(op.payment_value), 2) AS category_revenue,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    ROUND(AVG(op.payment_value), 2) AS avg_order_value
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN order_payments op ON oi.order_id = op.order_id
GROUP BY p.product_category_name
ORDER BY category_revenue DESC
LIMIT 10;

SELECT 
    c.customer_state,
    ROUND(SUM(op.payment_value), 2) AS state_revenue,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(AVG(op.payment_value), 2) AS avg_order_value
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_payments op ON o.order_id = op.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY state_revenue DESC
LIMIT 10;

SELECT 
    order_status,
    COUNT(*) AS total_orders,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

SELECT 
    s.seller_id,
    s.seller_city,
    s.seller_state,
    ROUND(SUM(op.payment_value), 2) AS seller_revenue,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    ROUND(AVG(op.payment_value), 2) AS avg_order_value
FROM sellers s
JOIN order_items oi ON s.seller_id = oi.seller_id
JOIN order_payments op ON oi.order_id = op.order_id
GROUP BY s.seller_id, s.seller_city, s.seller_state
ORDER BY seller_revenue DESC
LIMIT 10;

SELECT 
    ROUND(AVG(DATEDIFF(order_delivered_customer_date, 
                       order_purchase_timestamp)), 1) AS avg_delivery_days,
    ROUND(AVG(DATEDIFF(order_estimated_delivery_date, 
                       order_delivered_customer_date)), 1) AS avg_days_early,
    COUNT(CASE WHEN order_delivered_customer_date > order_estimated_delivery_date 
               THEN 1 END) AS late_deliveries,
    COUNT(CASE WHEN order_delivered_customer_date <= order_estimated_delivery_date 
               THEN 1 END) AS on_time_deliveries
FROM orders
WHERE order_status = 'delivered'
AND order_delivered_customer_date IS NOT NULL;

SELECT 
    payment_type,
    COUNT(*) AS total_transactions,
    ROUND(SUM(payment_value), 2) AS total_revenue,
    ROUND(AVG(payment_value), 2) AS avg_payment,
    ROUND(AVG(payment_installments), 1) AS avg_installments
FROM order_payments
GROUP BY payment_type
ORDER BY total_revenue DESC;

SELECT 
    review_score,
    COUNT(*) AS total_reviews,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentages
FROM order_reviews
GROUP BY review_score
ORDER BY review_score DESC;