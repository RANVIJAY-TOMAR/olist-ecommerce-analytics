# Olist Brazilian E-Commerce Analytics

## Project Overview
End-to-end data analytics project on the Olist Brazilian E-Commerce dataset (100K+ orders, 1M+ records). Built a complete analytics pipeline from MySQL database design to Python EDA to Power BI dashboard.

## Tools & Technologies
- Database: MySQL 8.0 (8 tables, 1M+ rows)
- Languages: SQL (Advanced), Python 3.13
- Libraries: Pandas, NumPy, Matplotlib, Seaborn
- Visualization: Power BI Desktop
- Techniques: RFM Analysis, Customer Segmentation, Window Functions, Churn Analysis

## Dataset
- Source: Olist Brazilian E-Commerce Dataset (Kaggle)
- Size: 1M+ rows across 8 tables
- Period: 2016-2018

## Key Findings
1. 97% customer churn - Only 3% of customers ever make a repeat purchase
2. Sao Paulo generates 36% of total revenue (R$5.77M)
3. R$16M total revenue across 99K orders, avg order value R$154
4. 97% delivery success rate, avg 12.5 days, arriving 11.9 days early
5. Credit card dominates at 78% of transactions with avg 3.5 installments
6. Northern states pay 28% of product price in freight vs 10% in Sao Paulo

## Dashboard Pages
- Page 1: Executive Summary - KPI cards, monthly revenue trend, order status
- Page 2: Product Analysis - Top categories, review scores
- Page 3: Customer Segmentation - RFM segments, revenue by segment
- Page 4: Geographic Analysis - Orders by state, payment methods

## SQL Highlights
- 30+ queries covering revenue, RFM, product, seller, and window function analysis
- Techniques: CTEs, NTILE, ROW_NUMBER, LAG, PARTITION BY, rolling averages
- RFM scoring across 93K unique customers

## Project Files
- day2_revenue_analysis.sql
- day3_rfm_analysis.sql
- day4_product_seller_analysis.sql
- day6_advanced_sql.sql
- day5_eda.ipynb
- olist.pbix
  
Power BI Dashboard: [View Dashboard](https://drive.google.com/file/d/10U2J2RDh3_T262cAgwgPMKED2Dt5Q1Z7/view?usp=sharing)

## Author
Ranvijay Singh Tomar
B.Tech CSE & Data Science | G.L. Bajaj Institute of Technology & Management
