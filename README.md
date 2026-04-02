# SQL-Interview-Prep
Complete SQL interview prep — UNION ALL, JOINs, Window Functions


🗄️ SQL Interview Prep — UNION ALL Mastery

From zero to interview-ready on one of the most asked SQL topics in product-based company interviews.


📌 What is this?
This repository contains 15 real-world SQL problems built around UNION ALL — progressing from basic filters all the way to advanced interview patterns combining CTEs, Window Functions, Aggregations and CASE WHEN — the exact patterns asked at companies like Flipkart, Amazon, Swiggy, and Zepto.
Every problem includes:

✅ Real business scenario
✅ Table creation + insert scripts (ready to run on SQL Server)
✅ Solution query with clean comments


🧠 Topics Covered
TopicProblemsUNION ALL + Filters + Aggregations1 – 4UNION ALL + GROUP BY + HAVING5 – 7UNION ALL + Window Functions (DENSE_RANK, ROW_NUMBER)8 – 11UNION ALL + CTEs + LAG + Running Totals12 – 15

📂 Problems Overview
#ScenarioKey Concepts1ICC World Cup — Matches Played, Won, Lost per TeamUNION ALL + CASE WHEN + GROUP BY2E-commerce — Total Orders & Revenue for March 2024UNION ALL + Date Filter + Aggregation3Employee Directory — Full-Time vs Contract LabelUNION ALL + Hardcoded Labels + IN filter4Retail Sales — Category-wise Revenue for 2024UNION ALL + GROUP BY + ORDER BY5Customer Purchases — High Value Customers (Spend > 10K)UNION ALL + GROUP BY + HAVING6Product Sales — Category Performance H1 2024UNION ALL + Multiple Aggregations + HAVING7Sales Rep — Performance Report (Deals > 3)UNION ALL + COUNT + HAVING8Multi-Channel Marketing — City-wise Spend ReportUNION ALL + 3 Tables + Multiple HAVING Conditions9Sales Ranking — Global Rank by RevenueUNION ALL + DENSE_RANK()10Region-wise — Top Performer Per RegionUNION ALL + DENSE_RANK() + PARTITION BY11Top 2 Products — Per Category Across StoresUNION ALL + Top N Per Group Pattern12Alternating Rows — Male Female InterleavingUNION ALL + ROW_NUMBER() + ORDER BY trick13Running Total — Revenue Accumulation Per RegionCTE + UNION ALL + SUM OVER (PARTITION BY)14Loyalty Tiers — Platinum, Gold, Silver, BronzeUNION ALL + GROUP BY + CASE WHEN15Month over Month Growth — Revenue & Growth %CTE + UNION ALL + LAG() + Growth % formula

💡 Key Patterns You Will Learn
1. Basic UNION ALL
sqlSELECT * FROM table_a
UNION ALL
SELECT * FROM table_b
2. UNION ALL + Filter After Combining
sqlSELECT * FROM (
    SELECT * FROM table_a
    UNION ALL
    SELECT * FROM table_b
) t
WHERE sale_date >= '2024-01-01' AND sale_date < '2025-01-01'
3. UNION ALL + Hardcoded Label Column
sqlSELECT emp_name, 'Full-Time' AS emp_type FROM full_time_employees
UNION ALL
SELECT emp_name, 'Contract'  AS emp_type FROM contract_employees
4. Top N Per Group (Most Asked Interview Pattern)
sqlSELECT * FROM (
    SELECT category, product_name,
           SUM(revenue) AS total_revenue,
           DENSE_RANK() OVER (PARTITION BY category ORDER BY SUM(revenue) DESC) AS rnk
    FROM (
        SELECT * FROM store_a UNION ALL SELECT * FROM store_b
    ) t
    GROUP BY category, product_name
) ranked
WHERE rnk <= 2
5. Alternating Rows — Flipkart Interview Pattern
sqlSELECT candidate_name, gender, score
FROM (
    SELECT candidate_name, gender, score,
           ROW_NUMBER() OVER (ORDER BY score DESC) AS rn
    FROM candidates WHERE gender = 'Male'
    UNION ALL
    SELECT candidate_name, gender, score,
           ROW_NUMBER() OVER (ORDER BY score DESC) AS rn
    FROM candidates WHERE gender = 'Female'
) t
ORDER BY rn, gender DESC
6. Month over Month Growth with LAG()
sqlWITH combined AS (...),
grouped AS (
    SELECT MONTH(sale_date) AS month_num,
           SUM(amount) AS total_revenue
    FROM combined GROUP BY MONTH(sale_date)
),
prev_rvn AS (
    SELECT *, LAG(total_revenue) OVER (ORDER BY month_num) AS prev_revenue
    FROM grouped
)
SELECT month_num, total_revenue,
       ROUND((total_revenue - prev_revenue) * 100.0 / prev_revenue, 2) AS growth_pct
FROM prev_rvn

⚡ Quick Tips Learned
TipWhy It MattersUse sale_date >= '2024-01-01' AND sale_date < '2025-01-01' instead of YEAR(sale_date) = 2024Allows SQL Server to use indexes — faster on large tablesUse < first day of next month instead of <= last day of current monthNever have to memorize days in each monthUse HAVING to filter aggregates, WHERE to filter rowsCommon interview question — know the differenceAlways repeat aggregate in HAVING, don't use aliasSQL Server doesn't allow alias in HAVINGUse 100.0 not 100 in growth % formulaAvoids integer division giving wrong resultsIf filtering on window function result — wrap in outer queryWindow functions can't be filtered with WHERE directlyUse DENSE_RANK() when ties should get same rankROW_NUMBER() for unique sequential, DENSE_RANK() for ties


🛠️ How to Use This Repo

Open SQL Server Management Studio (SSMS)
Create a new database: CREATE DATABASE sql_interview_prep
Run USE sql_interview_prep
Open Union_all_mastery.sql
Run each problem section by section
Try solving before looking at the solution! 💪


📈 Difficulty Progression
🟢 Problems  1–4   → Warm-up       (UNION ALL + basic filters + aggregation)
🟡 Problems  5–8   → Medium        (GROUP BY + HAVING + multiple conditions)
🟠 Problems  9–12  → Hard          (Window Functions + PARTITION BY + Top N)
🔴 Problems 13–15  → Interview     (CTEs + LAG + Running Totals + MoM Growth)
