-- RFM Customer Segmentation

WITH rfm AS (
    SELECT
        o.customer_id,
        MAX(o.order_date) AS last_purchase_date,
        COUNT(DISTINCT o.order_id) AS frequency,
        SUM(oi.price * oi.quantity) AS monetary
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY o.customer_id
)
SELECT
    customer_id,
    last_purchase_date,
    frequency,
    monetary,
    NTILE(4) OVER (ORDER BY last_purchase_date DESC) AS recency_score,
    NTILE(4) OVER (ORDER BY frequency) AS frequency_score,
    NTILE(4) OVER (ORDER BY monetary) AS monetary_score
FROM rfm;
