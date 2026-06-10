USE olist_ecommerce;

SELECT 
    p.product_category_name,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    COUNT(DISTINCT oi.product_id) AS unique_products,
    ROUND(SUM(op.payment_value), 2) AS total_revenue,
    ROUND(AVG(op.payment_value), 2) AS avg_order_value,
    ROUND(AVG(r.review_score), 2) AS avg_review_score
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN order_payments op ON oi.order_id = op.order_id
JOIN order_reviews r ON oi.order_id = r.order_id
GROUP BY p.product_category_name
ORDER BY total_revenue DESC
LIMIT 15;

SELECT 
    s.seller_id,
    s.seller_city,
    s.seller_state,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    ROUND(AVG(r.review_score), 2) AS avg_review_score,
    ROUND(AVG(DATEDIFF(o.order_delivered_customer_date,
                       o.order_purchase_timestamp)), 1) AS avg_delivery_days,
    SUM(CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date 
             THEN 1 ELSE 0 END) AS late_deliveries,
    ROUND(SUM(CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date 
                   THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS late_rate_pct
FROM sellers s
JOIN order_items oi ON s.seller_id = oi.seller_id
JOIN orders o ON oi.order_id = o.order_id
JOIN order_reviews r ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
AND o.order_delivered_customer_date IS NOT NULL
GROUP BY s.seller_id, s.seller_city, s.seller_state
HAVING total_orders >= 50
ORDER BY avg_review_score DESC
LIMIT 15;

SELECT 
    s.seller_id,
    s.seller_city,
    s.seller_state,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    ROUND(AVG(r.review_score), 2) AS avg_review_score,
    ROUND(AVG(DATEDIFF(o.order_delivered_customer_date,
                       o.order_purchase_timestamp)), 1) AS avg_delivery_days,
    ROUND(SUM(CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date 
                   THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS late_rate_pct
FROM sellers s
JOIN order_items oi ON s.seller_id = oi.seller_id
JOIN orders o ON oi.order_id = o.order_id
JOIN order_reviews r ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
AND o.order_delivered_customer_date IS NOT NULL
GROUP BY s.seller_id, s.seller_city, s.seller_state
HAVING total_orders >= 30
ORDER BY avg_review_score ASC
LIMIT 10;

SELECT 
    c.customer_state,
    ROUND(AVG(oi.freight_value), 2) AS avg_freight,
    ROUND(AVG(oi.price), 2) AS avg_product_price,
    ROUND(AVG(oi.freight_value) / AVG(oi.price) * 100, 2) AS freight_to_price_pct,
    COUNT(DISTINCT oi.order_id) AS total_orders
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY avg_freight DESC
LIMIT 15;

SELECT 
    p.product_category_name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(CASE WHEN o.order_status = 'canceled' THEN 1 ELSE 0 END) AS cancelled_orders,
    ROUND(SUM(CASE WHEN o.order_status = 'canceled' THEN 1 ELSE 0 END) 
          * 100.0 / COUNT(DISTINCT o.order_id), 2) AS cancellation_rate_pct
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
GROUP BY p.product_category_name
HAVING total_orders >= 50
ORDER BY cancellation_rate_pct DESC
LIMIT 10;

SELECT 
    p.product_category_name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(CASE WHEN o.order_status = 'canceled' THEN 1 ELSE 0 END) AS cancelled_orders,
    ROUND(SUM(CASE WHEN o.order_status = 'canceled' THEN 1 ELSE 0 END) 
          * 100.0 / COUNT(DISTINCT o.order_id), 2) AS cancellation_rate_pct
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
GROUP BY p.product_category_name
HAVING total_orders >= 50
ORDER BY cancellation_rate_pct DESC
LIMIT 10;

SELECT 
    p.product_id,
    p.product_category_name,
    COUNT(DISTINCT r.review_id) AS total_reviews,
    ROUND(AVG(r.review_score), 2) AS avg_review_score,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    ROUND(AVG(op.payment_value), 2) AS avg_price
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN order_reviews r ON oi.order_id = r.order_id
JOIN order_payments op ON oi.order_id = op.order_id
GROUP BY p.product_id, p.product_category_name
ORDER BY total_reviews DESC
LIMIT 10;