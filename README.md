## 🗄️ SQL Interview Prep — UNION ALL Mastery

> From zero to interview-ready on one of the most asked SQL topics in product-based company interviews.

---

## 📌 What is this?

This repository contains **15 real-world SQL problems** built around `UNION ALL` — progressing from basic filters all the way to advanced interview patterns combining **CTEs, Window Functions, Aggregations and CASE WHEN** — the exact patterns asked at companies like Flipkart, Amazon, Swiggy, and Zepto.

Every problem includes:
- ✅ Real business scenario
- ✅ Table creation + insert scripts (ready to run on SQL Server)
- ✅ Solution query with clean comments

---

## 🧠 Topics Covered

| Topic | Problems |
|---|---|
| UNION ALL + Filters + Aggregations | 1 – 4 |
| UNION ALL + GROUP BY + HAVING | 5 – 7 |
| UNION ALL + Window Functions (DENSE_RANK, ROW_NUMBER) | 8 – 11 |
| UNION ALL + CTEs + LAG + Running Totals | 12 – 15 |

---

## 📂 Problems Overview

| # | Scenario | Key Concepts |
|---|---|---|
| 1 | ICC World Cup — Matches Played, Won, Lost per Team | UNION ALL + CASE WHEN + GROUP BY |
| 2 | E-commerce — Total Orders & Revenue for March 2024 | UNION ALL + Date Filter + Aggregation |
| 3 | Employee Directory — Full-Time vs Contract Label | UNION ALL + Hardcoded Labels + IN filter |
| 4 | Retail Sales — Category-wise Revenue for 2024 | UNION ALL + GROUP BY + ORDER BY |
| 5 | Customer Purchases — High Value Customers (Spend > 10K) | UNION ALL + GROUP BY + HAVING |
| 6 | Product Sales — Category Performance H1 2024 | UNION ALL + Multiple Aggregations + HAVING |
| 7 | Sales Rep — Performance Report (Deals > 3) | UNION ALL + COUNT + HAVING |
| 8 | Multi-Channel Marketing — City-wise Spend Report | UNION ALL + 3 Tables + Multiple HAVING Conditions |
| 9 | Sales Ranking — Global Rank by Revenue | UNION ALL + DENSE_RANK() |
| 10 | Region-wise — Top Performer Per Region | UNION ALL + DENSE_RANK() + PARTITION BY |
| 11 | Top 2 Products — Per Category Across Stores | UNION ALL + Top N Per Group Pattern |
| 12 | Alternating Rows — Male Female Interleaving | UNION ALL + ROW_NUMBER() + ORDER BY trick |
| 13 | Running Total — Revenue Accumulation Per Region | CTE + UNION ALL + SUM OVER (PARTITION BY) |
| 14 | Loyalty Tiers — Platinum, Gold, Silver, Bronze | UNION ALL + GROUP BY + CASE WHEN |
| 15 | Month over Month Growth — Revenue & Growth % | CTE + UNION ALL + LAG() + Growth % formula |

---

## 💡 Key Patterns You Will Learn

### 1. Basic UNION ALL
```sql
SELECT * FROM table_a
UNION ALL
SELECT * FROM table_b
```

### 2. UNION ALL + Filter After Combining
```sql
SELECT * FROM (
    SELECT * FROM table_a
    UNION ALL
    SELECT * FROM table_b
) t
WHERE sale_date >= '2024-01-01' AND sale_date < '2025-01-01'
```

### 3. UNION ALL + Hardcoded Label Column
```sql
SELECT emp_name, 'Full-Time' AS emp_type FROM full_time_employees
UNION ALL
SELECT emp_name, 'Contract'  AS emp_type FROM contract_employees
```

### 4. Top N Per Group (Most Asked Interview Pattern)
```sql
SELECT * FROM (
    SELECT category, product_name,
           SUM(revenue) AS total_revenue,
           DENSE_RANK() OVER (PARTITION BY category ORDER BY SUM(revenue) DESC) AS rnk
    FROM (
        SELECT * FROM store_a UNION ALL SELECT * FROM store_b
    ) t
    GROUP BY category, product_name
) ranked
WHERE rnk <= 2
```

### 5. Alternating Rows — Flipkart Interview Pattern
```sql
SELECT candidate_name, gender, score
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
```

### 6. Month over Month Growth with LAG()
```sql
WITH combined AS (...),
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
```

---

## ⚡ Quick Tips Learned

| Tip | Why It Matters |
|---|---|
| Use date range instead of `YEAR(sale_date)` | Allows SQL Server to use indexes — faster on large tables |
| Use `< first day of next month` instead of `<= last day` | Never have to memorize days in each month |
| Use `HAVING` to filter aggregates, `WHERE` to filter rows | Very common interview question |
| Always repeat aggregate in `HAVING`, don't use alias | SQL Server doesn't allow alias in HAVING |
| Use `100.0` not `100` in growth % formula | Avoids integer division giving wrong results |
| Filter on window function result — wrap in outer query | Window functions can't be filtered with WHERE directly |
| Use `DENSE_RANK()` when ties should get same rank | `ROW_NUMBER()` for unique sequential, `DENSE_RANK()` for ties |



## 🛠️ How to Use This Repo

1. Open **SQL Server Management Studio (SSMS)**
2. Create a new database: `CREATE DATABASE sql_interview_prep`
3. Run `USE sql_interview_prep`
4. Open `Union_all_mastery.sql`
5. Try solving each problem before looking at the solution! 💪

---

## 📈 Difficulty Progression
```
🟢 Problems  1–4   → Warm-up       (UNION ALL + basic filters + aggregation)
🟡 Problems  5–8   → Medium        (GROUP BY + HAVING + multiple conditions)
🟠 Problems  9–12  → Hard          (Window Functions + PARTITION BY + Top N)
🔴 Problems 13–15  → Interview     (CTEs + LAG + Running Totals + MoM Growth)
```

---


---

*Built with 💪 through practice — one problem at a time.*
