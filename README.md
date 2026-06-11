# 🛒 Olist Brazilian E-Commerce Analytics

> End-to-end analytics pipeline on 1M+ rows of real Brazilian e-commerce data — from MySQL database design to Python EDA to a 4-page interactive Power BI dashboard.

![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=flat-square&logo=mysql&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=flat-square&logo=python&logoColor=white)
![Power BI](https://img.shields.io/badge/Power_BI-F2C811?style=flat-square&logo=powerbi&logoColor=black)
![Pandas](https://img.shields.io/badge/Pandas-150458?style=flat-square&logo=pandas&logoColor=white)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen?style=flat-square)

---

## 🎯 Business Problem

Olist is Brazil's largest e-commerce marketplace. With 100K+ orders across 2016–2018, the business needed answers to critical questions:

- Why are customers not coming back?
- Which regions and product categories drive the most revenue?
- Which customers are most valuable — and which are at risk of churning?
- Are deliveries meeting customer expectations?

This project addresses all four using SQL, Python, and a Power BI executive dashboard.

---

## 🔍 Key Findings

| # | Finding | Business Impact |
|---|---------|----------------|
| 🔴 | **97% of customers never make a second purchase** | Critical retention risk — loyalty program needed urgently |
| 📍 | **São Paulo drives 36% of total revenue (R$5.77M)** | Over-reliance on one region — expansion opportunity in Rio, MG |
| 🚚 | **Northern states pay 28% of product price in freight vs 10% in SP** | Freight disparity limiting market penetration in the North |
| 💳 | **Credit card dominates at 78% of transactions, avg 3.5 installments** | Installment culture is key — optimize for EMI-friendly pricing |
| ✅ | **97% delivery success rate, arriving 11.9 days ahead of estimate** | Strong logistics — under-promising and over-delivering |
| 💰 | **R$16M total revenue across 99K orders, avg order value R$154** | Baseline KPIs for growth benchmarking |

---

## 🏗️ Project Architecture

```
Raw CSV Files (Kaggle)
        │
        ▼
MySQL Database (8 tables, 1M+ rows)
        │
        ├── 30+ SQL Queries (Revenue, RFM, Product, Seller, Window Functions)
        │
        ▼
Python EDA (Pandas, Matplotlib, Seaborn)
        │
        ├── 8 Business Visualizations
        │
        ▼
Power BI Dashboard (4 Pages)
        │
        └── Executive KPIs → Product Analysis → Customer Segmentation → Geo Revenue
```

---

## 📊 Power BI Dashboard

**[▶ View Live Dashboard](https://drive.google.com/file/d/10U2J2RDh3_T262cAgwgPMKED2Dt5Q1Z7/view?usp=sharing)**

| Page | Focus | Key Visuals |
|------|-------|-------------|
| 1 — Executive Summary | Top-level KPIs | Revenue trend, order status, delivery performance |
| 2 — Product Analysis | Category performance | Top categories by revenue, avg review scores |
| 3 — Customer Segmentation | RFM segments | Champions vs At-Risk vs Lost customers |
| 4 — Geographic Analysis | Regional breakdown | Orders by state, freight cost heatmap, payment methods |

---

## 🗄️ Database Design

- **8 normalized tables** — orders, customers, products, sellers, order_items, payments, reviews, geolocation
- **1M+ rows** of transactional data across 2016–2018
- **93K unique customers** scored using RFM (Recency, Frequency, Monetary) model

---

## 🧠 SQL Highlights

30+ advanced queries covering:

- **Revenue Analysis** — monthly trends, YoY growth, category breakdown
- **RFM Segmentation** — NTILE scoring across 93K customers into Champions, Loyal, At-Risk, Lost
- **Churn Detection** — LAG + window functions to identify one-time vs repeat buyers
- **Seller Performance** — ranking sellers by revenue, reviews, and delivery speed
- **Freight Analysis** — PARTITION BY state to compare freight-to-price ratios regionally

```sql
-- Example: RFM Scoring using Window Functions
WITH rfm_base AS (
  SELECT
    customer_id,
    DATEDIFF('2018-12-31', MAX(order_purchase_timestamp)) AS recency,
    COUNT(DISTINCT order_id)                               AS frequency,
    SUM(payment_value)                                     AS monetary
  FROM orders
  JOIN payments USING (order_id)
  WHERE order_status = 'delivered'
  GROUP BY customer_id
),
rfm_scores AS (
  SELECT *,
    NTILE(5) OVER (ORDER BY recency DESC)   AS r_score,
    NTILE(5) OVER (ORDER BY frequency)      AS f_score,
    NTILE(5) OVER (ORDER BY monetary)       AS m_score
  FROM rfm_base
)
SELECT *,
  CASE
    WHEN r_score >= 4 AND f_score >= 4 THEN 'Champion'
    WHEN r_score >= 3 AND f_score >= 3 THEN 'Loyal'
    WHEN r_score <= 2 AND f_score <= 2 THEN 'Lost'
    ELSE 'At Risk'
  END AS segment
FROM rfm_scores;
```

---

## 📁 Repository Structure

```
olist-ecommerce-analytics/
│
├── sql/
│   ├── day2_revenue_analysis.sql
│   ├── day3_rfm_analysis.sql
│   ├── day4_product_seller_analysis.sql
│   └── day6_advanced_sql.sql
│
├── notebooks/
│   └── day5_eda.ipynb
│
├── dashboard/
│   └── olist.pbix
│
└── README.md
```

---

## 🛠️ Tech Stack

| Layer | Tool |
|-------|------|
| Database | MySQL 8.0 |
| Language | Python 3.13, SQL |
| EDA Libraries | Pandas, NumPy, Matplotlib, Seaborn |
| BI Dashboard | Power BI Desktop |
| Dataset | [Olist on Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) |

---

## 👤 Author

**Ranvijay Singh Tomar**
B.Tech — Computer Science & Data Science | G.L. Bajaj Institute of Technology & Management (AKTU)

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0A66C2?style=flat-square&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/ranvijay-singh-tomar/)
[![GitHub](https://img.shields.io/badge/GitHub-181717?style=flat-square&logo=github&logoColor=white)](https://github.com/RANVIJAY-TOMAR)
