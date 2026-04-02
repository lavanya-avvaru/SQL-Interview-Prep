/*
================================================
   UNION ALL MASTERY — SQL Interview Prep
   Author: [Your Name]
   Topics: UNION ALL + GROUP BY + Window Functions + CTEs
   Level: Basic to Interview Level (15 Problems)
================================================
*/
use final_practice


----================1st problem================================
create table icc_world_cup
(
Team_1 Varchar(20),
Team_2 Varchar(20),
Winner Varchar(20)
);
INSERT INTO icc_world_cup values('India','SL','India');
INSERT INTO icc_world_cup values('SL','Aus','Aus');
INSERT INTO icc_world_cup values('SA','Eng','Eng');
INSERT INTO icc_world_cup values('Eng','NZ','NZ');
INSERT INTO icc_world_cup values('Aus','India','India');

select * from icc_world_cup;

--output team, number of matches played, match won, match lost
select Team, count(*) as match_played, sum(win_flag) as match_won, count(*)-sum(win_flag) as match_lost from
(
select Team_1 as Team, case when Team_1=Winner then 1 else 0 end as win_flag
from icc_world_cup
union all
select Team_2, case when Team_2=Winner then 1 else 0 end as win_flag
from icc_world_cup
)t
group by Team 
order by match_won desc



-----=================Problem 2 =====================================
---to display the number of orders, revenue for the month of march 
-- Create Tables
CREATE TABLE online_orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    amount DECIMAL(10,2),
    order_date DATE
);

CREATE TABLE instore_orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    amount DECIMAL(10,2),
    order_date DATE
);

-- Insert into online_orders
INSERT INTO online_orders VALUES (1, 101, 250.00, '2024-03-01');
INSERT INTO online_orders VALUES (2, 102, 180.50, '2024-03-05');
INSERT INTO online_orders VALUES (3, 103, 320.00, '2024-03-10');
INSERT INTO online_orders VALUES (4, 104, 95.75,  '2024-03-15');
INSERT INTO online_orders VALUES (5, 105, 410.00, '2024-03-20');
INSERT INTO online_orders VALUES (6, 106, 60.00,  '2024-02-28'); -- outside March

-- Insert into instore_orders
INSERT INTO instore_orders VALUES (101, 201, 150.00, '2024-03-02');
INSERT INTO instore_orders VALUES (102, 202, 200.00, '2024-03-08');
INSERT INTO instore_orders VALUES (103, 203, 540.00, '2024-03-12');
INSERT INTO instore_orders VALUES (104, 204, 75.00,  '2024-03-18');
INSERT INTO instore_orders VALUES (105, 205, 305.50, '2024-03-25');
INSERT INTO instore_orders VALUES (106, 206, 90.00,  '2024-02-20'); -- outside March

select count(*) as 'no of orders', sum(amount) as revenue from 
(
select * from online_orders where order_date >= '2024-03-01' AND order_date < '2024-04-01'
union all
select * from instore_orders where order_date >= '2024-03-01' AND order_date < '2024-04-01'
)t



-------============Problem 3 ============================================
--Write a query that returns all employees from both tables who belong to Finance or Engineering, with a new column that labels whether they are 'Full-Time' or 'Contract'.

CREATE TABLE full_time_employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100),
    department VARCHAR(50),
    salary DECIMAL(10,2)
);

CREATE TABLE contract_employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100),
    department VARCHAR(50),
    salary DECIMAL(10,2)
);

INSERT INTO full_time_employees VALUES (1, 'Alice',   'Finance',     80000);
INSERT INTO full_time_employees VALUES (2, 'Bob',     'Engineering', 95000);
INSERT INTO full_time_employees VALUES (3, 'Charlie', 'HR',          60000);
INSERT INTO full_time_employees VALUES (4, 'Diana',   'Engineering', 105000);
INSERT INTO full_time_employees VALUES (5, 'Eve',     'Marketing',   70000);

INSERT INTO contract_employees VALUES (101, 'Frank',  'Finance',     50000);
INSERT INTO contract_employees VALUES (102, 'Grace',  'Engineering', 72000);
INSERT INTO contract_employees VALUES (103, 'Hank',   'HR',          45000);
INSERT INTO contract_employees VALUES (104, 'Ivy',    'Finance',     55000);
INSERT INTO contract_employees VALUES (105, 'Jake',   'Marketing',   48000);




select * from full_time_employees;
select * from contract_employees;


select emp_name, emp_type, department, salary  from (
SELECT emp_id, emp_name, department, salary, 'Full-Time' AS emp_type FROM full_time_employees
union all
SELECT emp_id, emp_name, department, salary, 'Contract-Time' AS emp_type FROM contract_employees
)t
where department = 'Finance' or department = 'Engineering'



-------============Problem 4 ============================================
--Write a query that returns category and total revenue, sorted by revenue highest to lowest for the year 2024

CREATE TABLE north_region_sales (
    sale_id INT PRIMARY KEY,
    product VARCHAR(100),
    category VARCHAR(50),
    amount DECIMAL(10,2),
    sale_date DATE
);

CREATE TABLE south_region_sales (
    sale_id INT PRIMARY KEY,
    product VARCHAR(100),
    category VARCHAR(50),
    amount DECIMAL(10,2),
    sale_date DATE
);

INSERT INTO north_region_sales VALUES (1,  'Laptop',   'Electronics', 80000, '2024-01-15');
INSERT INTO north_region_sales VALUES (2,  'Shirt',    'Clothing',    1200,  '2024-02-10');
INSERT INTO north_region_sales VALUES (3,  'TV',       'Electronics', 50000, '2024-03-05');
INSERT INTO north_region_sales VALUES (4,  'Sofa',     'Furniture',   30000, '2024-04-20');
INSERT INTO north_region_sales VALUES (5,  'Jeans',    'Clothing',    2500,  '2024-05-18');
INSERT INTO north_region_sales VALUES (6,  'Mixer',    'Appliances',  4000,  '2023-11-11'); -- 2023

INSERT INTO south_region_sales VALUES (101, 'Phone',   'Electronics', 60000, '2024-01-22');
INSERT INTO south_region_sales VALUES (102, 'Dress',   'Clothing',    1800,  '2024-02-14');
INSERT INTO south_region_sales VALUES (103, 'Washing Machine', 'Appliances', 35000, '2024-03-30');
INSERT INTO south_region_sales VALUES (104, 'Dining Table',   'Furniture',  45000, '2024-06-10');
INSERT INTO south_region_sales VALUES (105, 'Headphones',     'Electronics', 8000, '2024-07-25');
INSERT INTO south_region_sales VALUES (106, 'Microwave',      'Appliances', 12000, '2023-12-05'); -- 2023


select * from north_region_sales;
select * from south_region_sales;

select category, sum(amount) as total_revenue from 
(
select category, amount, sale_date from north_region_sales
union all
select category, amount, sale_date from south_region_sales
)t 
where sale_date >= '2024-01-01'
group by category
order by total_revenue desc

-------============Problem 5 ============================================

--customers who have spent more than 10,000 in total across both the app and website combined.
--They want the customer name, and their total spending, sorted by highest spenders first.

CREATE TABLE app_purchases (
    purchase_id INT PRIMARY KEY,
    customer_id INT,
    customer_name VARCHAR(100),
    amount DECIMAL(10,2),
    purchase_date DATE
);

CREATE TABLE website_purchases (
    purchase_id INT PRIMARY KEY,
    customer_id INT,
    customer_name VARCHAR(100),
    amount DECIMAL(10,2),
    purchase_date DATE
);

INSERT INTO app_purchases VALUES (1, 101, 'Ravi',    4500, '2024-01-10');
INSERT INTO app_purchases VALUES (2, 102, 'Sneha',   8000, '2024-02-15');
INSERT INTO app_purchases VALUES (3, 103, 'Kiran',   1200, '2024-03-05');
INSERT INTO app_purchases VALUES (4, 101, 'Ravi',    3000, '2024-04-20');
INSERT INTO app_purchases VALUES (5, 104, 'Meera',   6000, '2024-05-18');

INSERT INTO website_purchases VALUES (101, 101, 'Ravi',   5000, '2024-02-01');
INSERT INTO website_purchases VALUES (102, 102, 'Sneha',  4000, '2024-03-10');
INSERT INTO website_purchases VALUES (103, 103, 'Kiran',  9500, '2024-04-15');
INSERT INTO website_purchases VALUES (104, 104, 'Meera',  7000, '2024-06-01');
INSERT INTO website_purchases VALUES (105, 105, 'Arjun',  3000, '2024-07-20');

select * from app_purchases;
select * from website_purchases;


select customer_name, sum(amount) as total from 
(
select customer_name, amount from app_purchases
union all
select customer_name, amount from website_purchases
)t 
group by customer_name
having sum(amount) > 10000
order by total desc


-------============Problem 6 ============================================


--category-wise performance report for the first half of 2024 (Q1 + Q2 combined). They want:

--Category
--Total quantity sold
--Total revenue
--Average order value
--Only categories where total revenue is above 50,000

CREATE TABLE q1_sales (
    sale_id INT PRIMARY KEY,
    product_id INT,
    product_name VARCHAR(100),
    category VARCHAR(50),
    quantity_sold INT,
    amount DECIMAL(10,2),
    sale_date DATE
);

CREATE TABLE q2_sales (
    sale_id INT PRIMARY KEY,
    product_id INT,
    product_name VARCHAR(100),
    category VARCHAR(50),
    quantity_sold INT,
    amount DECIMAL(10,2),
    sale_date DATE
);

INSERT INTO q1_sales VALUES (1, 1, 'Laptop',     'Electronics', 10, 80000, '2024-01-15');
INSERT INTO q1_sales VALUES (2, 2, 'Shirt',      'Clothing',     50, 15000, '2024-02-10');
INSERT INTO q1_sales VALUES (3, 3, 'Sofa',       'Furniture',     5, 25000, '2024-02-20');
INSERT INTO q1_sales VALUES (4, 4, 'Phone',      'Electronics',  15, 60000, '2024-03-05');
INSERT INTO q1_sales VALUES (5, 5, 'Dining Table','Furniture',    3, 18000, '2024-03-18');

INSERT INTO q2_sales VALUES (101, 1, 'Laptop',     'Electronics', 12, 96000, '2024-04-10');
INSERT INTO q2_sales VALUES (102, 2, 'Shirt',      'Clothing',     30,  9000, '2024-05-15');
INSERT INTO q2_sales VALUES (103, 3, 'Sofa',       'Furniture',     8, 40000, '2024-05-22');
INSERT INTO q2_sales VALUES (104, 6, 'Washing Machine','Appliances',6, 42000, '2024-06-01');
INSERT INTO q2_sales VALUES (105, 7, 'Headphones', 'Electronics',  20, 16000, '2024-06-18');


select category, sum(quantity_sold) as total_quantity_sold, sum(amount) as total_revenue, avg(amount) as average_order_val from
(

select category, quantity_sold, amount, sale_date from q1_sales
union all
select category, quantity_sold, amount, sale_date from q2_sales
)t
where sale_date>= '2024-01-01' and sale_date<'2024-07-01'
group by category 
having sum(amount) > 50000
order by total_revenue desc


-------============Problem 7 ============================================

--Scenario: The sales manager wants a sales rep performance report for the full year 2024. They want to know for each sales rep:

--Their region
--How many deals they closed
--Total revenue they generated
--Only reps who closed more than 3 deals across both halves combined

CREATE TABLE h1_sales (
    sale_id INT PRIMARY KEY,
    sales_rep VARCHAR(100),
    region VARCHAR(50),
    product VARCHAR(100),
    amount DECIMAL(10,2),
    sale_date DATE
);

CREATE TABLE h2_sales (
    sale_id INT PRIMARY KEY,
    sales_rep VARCHAR(100),
    region VARCHAR(50),
    product VARCHAR(100),
    amount DECIMAL(10,2),
    sale_date DATE
);

INSERT INTO h1_sales VALUES (1, 'Amit',  'North', 'Laptop',  45000, '2024-01-10');
INSERT INTO h1_sales VALUES (2, 'Priya', 'South', 'Phone',   30000, '2024-02-15');
INSERT INTO h1_sales VALUES (3, 'Amit',  'North', 'TV',      32000, '2024-03-05');
INSERT INTO h1_sales VALUES (4, 'Rahul', 'East',  'Sofa',    18000, '2024-04-20');
INSERT INTO h1_sales VALUES (5, 'Priya', 'South', 'Laptop',  47000, '2024-05-18');
INSERT INTO h1_sales VALUES (6, 'Rahul', 'East',  'Phone',   22000, '2024-06-25');

INSERT INTO h2_sales VALUES (101, 'Amit',  'North', 'Laptop',  51000, '2024-07-10');
INSERT INTO h2_sales VALUES (102, 'Priya', 'South', 'TV',      38000, '2024-08-15');
INSERT INTO h2_sales VALUES (103, 'Rahul', 'East',  'Sofa',    21000, '2024-09-05');
INSERT INTO h2_sales VALUES (104, 'Amit',  'North', 'Phone',   29000, '2024-10-20');
INSERT INTO h2_sales VALUES (105, 'Sneha', 'West',  'Laptop',  43000, '2024-11-18');
INSERT INTO h2_sales VALUES (106, 'Priya', 'South', 'Phone',   35000, '2024-12-25');

select * from h1_sales;
select * from h2_sales;

select sales_rep, region, count(*) as total_deals, sum(amount) as revenue from
(select sales_rep, region, amount, sale_date from h1_sales
union all
select sales_rep, region, amount, sale_date from h2_sales) t
where year(sale_date)=2024
group by sales_rep, region 
having count(*)>3 
order by total_deals desc


-------============Problem 8 ============================================


CREATE TABLE email_leads (
    lead_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(50),
    channel VARCHAR(50),
    amount_spent DECIMAL(10,2),
    lead_date DATE
);

CREATE TABLE social_leads (
    lead_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(50),
    channel VARCHAR(50),
    amount_spent DECIMAL(10,2),
    lead_date DATE
);

CREATE TABLE search_leads (
    lead_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(50),
    channel VARCHAR(50),
    amount_spent DECIMAL(10,2),
    lead_date DATE
);

INSERT INTO email_leads VALUES (1, 'Ravi',   'Mumbai',    'Email', 18000, '2024-01-10');
INSERT INTO email_leads VALUES (2, 'Sneha',  'Delhi',     'Email', 22000, '2024-02-15');
INSERT INTO email_leads VALUES (3, 'Kiran',  'Bangalore', 'Email', 12000, '2024-03-05');
INSERT INTO email_leads VALUES (4, 'Meera',  'Mumbai',    'Email', 15000, '2024-04-20');
INSERT INTO email_leads VALUES (5, 'Arjun',  'Delhi',     'Email', 19000, '2024-05-18');

INSERT INTO social_leads VALUES (101, 'Pooja',  'Mumbai',    'Social', 25000, '2024-02-01');
INSERT INTO social_leads VALUES (102, 'Rahul',  'Bangalore', 'Social', 31000, '2024-03-10');
INSERT INTO social_leads VALUES (103, 'Anita',  'Delhi',     'Social', 17000, '2024-04-15');
INSERT INTO social_leads VALUES (104, 'Vikram', 'Mumbai',    'Social', 22000, '2024-05-01');
INSERT INTO social_leads VALUES (105, 'Priya',  'Hyderabad', 'Social', 14000, '2024-06-20');

INSERT INTO search_leads VALUES (201, 'Suresh', 'Mumbai',    'Search', 20000, '2024-03-15');
INSERT INTO search_leads VALUES (202, 'Divya',  'Delhi',     'Search', 28000, '2024-04-10');
INSERT INTO search_leads VALUES (203, 'Manoj',  'Bangalore', 'Search', 19000, '2024-05-25');
INSERT INTO search_leads VALUES (204, 'Kavya',  'Hyderabad', 'Search', 11000, '2024-06-15');
INSERT INTO search_leads VALUES (205, 'Arun',   'Mumbai',    'Search', 16000, '2024-07-20');


--Scenario: The marketing head wants a city-wise marketing spend report across 
--ALL three channels — email, social media, and search ads combined for 2024. They want:

--City
--Total leads generated
--Total amount spent
--Average spend per lead
--Only cities where total spend is above 50,000
--Only cities where total leads are more than 3
--Sorted by total spend descending

select * from email_leads;
select * from social_leads;
select * from search_leads;

select city, count(*) as total_leads_generated, sum(amount_spent) as total_amount_spent, avg(amount_spent) as avg_spent from
(select city, channel, amount_spent, lead_date from email_leads
union all
select city, channel, amount_spent, lead_date from social_leads
union all
select city, channel, amount_spent, lead_date from search_leads
)t
where lead_date >= '2024-01-01' AND lead_date < '2025-01-01'
group by city
HAVING SUM(amount_spent) > 50000 AND COUNT(*) > 3
ORDER BY total_amount_spent DESC


-------============Problem 9 ============================================

--Scenario: The sales director wants to rank all sales reps by their total revenue generated across both online and offline channels combined. They want:

--Sales rep name
--Region
--Total revenue
--Their rank — top earner is Rank 1
--If two reps have the same revenue — they should get the same rank

CREATE TABLE online_sales (
    sale_id INT PRIMARY KEY,
    sales_rep VARCHAR(100),
    region VARCHAR(50),
    amount DECIMAL(10,2),
    sale_date DATE
);

CREATE TABLE offline_sales (
    sale_id INT PRIMARY KEY,
    sales_rep VARCHAR(100),
    region VARCHAR(50),
    amount DECIMAL(10,2),
    sale_date DATE
);

INSERT INTO online_sales VALUES (1, 'Amit',  'North', 45000, '2024-01-10');
INSERT INTO online_sales VALUES (2, 'Priya', 'South', 30000, '2024-02-15');
INSERT INTO online_sales VALUES (3, 'Rahul', 'East',  28000, '2024-03-05');
INSERT INTO online_sales VALUES (4, 'Sneha', 'West',  52000, '2024-04-20');
INSERT INTO online_sales VALUES (5, 'Amit',  'North', 33000, '2024-05-18');

INSERT INTO offline_sales VALUES (101, 'Priya', 'South', 48000, '2024-02-01');
INSERT INTO offline_sales VALUES (102, 'Rahul', 'East',  50000, '2024-03-10');
INSERT INTO offline_sales VALUES (103, 'Sneha', 'West',  25000, '2024-04-15');
INSERT INTO offline_sales VALUES (104, 'Amit',  'North', 22000, '2024-05-01');
INSERT INTO offline_sales VALUES (105, 'Kiran', 'South', 78000, '2024-06-20');
INSERT INTO offline_sales VALUES (106, 'Priya', 'South', 30000, '2024-07-18');


select * from online_sales;
select * from offline_sales;

select sales_rep, region, sum(amount) as total_revenue , dense_rank() over(order by sum(amount) desc) as rnk 
from  (
		select sales_rep, region, amount from online_sales
		union all
		select sales_rep, region, amount from offline_sales
	  ) t
group by sales_rep, region


-------============Problem 10 ============================================

----top performing employee in each region
---Region, Employee name, Their total sales, Only the #1 ranked employee per region

CREATE TABLE q1_performance (
    emp_id INT,
    emp_name VARCHAR(100),
    region VARCHAR(50),
    sales_amount DECIMAL(10,2),
    quarter VARCHAR(10)
);

CREATE TABLE q2_performance (
    emp_id INT,
    emp_name VARCHAR(100),
    region VARCHAR(50),
    sales_amount DECIMAL(10,2),
    quarter VARCHAR(10)
);

INSERT INTO q1_performance VALUES (1, 'Amit',   'North', 45000, 'Q1');
INSERT INTO q1_performance VALUES (2, 'Priya',  'South', 30000, 'Q1');
INSERT INTO q1_performance VALUES (3, 'Rahul',  'East',  28000, 'Q1');
INSERT INTO q1_performance VALUES (4, 'Sneha',  'West',  52000, 'Q1');
INSERT INTO q1_performance VALUES (5, 'Kiran',  'North', 38000, 'Q1');
INSERT INTO q1_performance VALUES (6, 'Meera',  'South', 41000, 'Q1');
INSERT INTO q1_performance VALUES (7, 'Vikram', 'East',  33000, 'Q1');
INSERT INTO q1_performance VALUES (8, 'Divya',  'West',  47000, 'Q1');

INSERT INTO q2_performance VALUES (1, 'Amit',   'North', 55000, 'Q2');
INSERT INTO q2_performance VALUES (2, 'Priya',  'South', 48000, 'Q2');
INSERT INTO q2_performance VALUES (3, 'Rahul',  'East',  50000, 'Q2');
INSERT INTO q2_performance VALUES (4, 'Sneha',  'West',  25000, 'Q2');
INSERT INTO q2_performance VALUES (5, 'Kiran',  'North', 42000, 'Q2');
INSERT INTO q2_performance VALUES (6, 'Meera',  'South', 39000, 'Q2');
INSERT INTO q2_performance VALUES (7, 'Vikram', 'East',  61000, 'Q2');
INSERT INTO q2_performance VALUES (8, 'Divya',  'West',  53000, 'Q2');



select * from q1_performance;
select * from q2_performance;


select region, emp_name, total_sales from (
select region, emp_name, sum(sales_amount) as total_sales, dense_rank() over(partition by region order by sum(sales_amount) desc) as rnk from
(select * from q1_performance 
union all
select * from q2_performance) t
group by region, emp_name) ranked
where rnk=1


-------============Problem 11 ============================================
/*Scenario: The category manager wants to see the top 2 revenue generating products in each category across both stores combined. They want:

Category
Product name
Total revenue
Their rank within the category
Only top 2 products per category */

CREATE TABLE store_a_sales (
    sale_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    revenue DECIMAL(10,2),
    sale_date DATE
);

CREATE TABLE store_b_sales (
    sale_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    revenue DECIMAL(10,2),
    sale_date DATE
);

INSERT INTO store_a_sales VALUES (1, 'Laptop',    'Electronics', 80000, '2024-01-15');
INSERT INTO store_a_sales VALUES (2, 'Phone',     'Electronics', 60000, '2024-02-10');
INSERT INTO store_a_sales VALUES (3, 'Headphones','Electronics', 20000, '2024-03-05');
INSERT INTO store_a_sales VALUES (4, 'Sofa',      'Furniture',   45000, '2024-04-20');
INSERT INTO store_a_sales VALUES (5, 'Dining Table','Furniture', 30000, '2024-05-18');
INSERT INTO store_a_sales VALUES (6, 'Bookshelf', 'Furniture',   15000, '2024-06-10');

INSERT INTO store_b_sales VALUES (101, 'Laptop',    'Electronics', 95000, '2024-01-22');
INSERT INTO store_b_sales VALUES (102, 'Tablet',    'Electronics', 40000, '2024-02-14');
INSERT INTO store_b_sales VALUES (103, 'Phone',     'Electronics', 55000, '2024-03-30');
INSERT INTO store_b_sales VALUES (104, 'Sofa',      'Furniture',   50000, '2024-04-25');
INSERT INTO store_b_sales VALUES (105, 'Wardrobe',  'Furniture',   35000, '2024-05-15');
INSERT INTO store_b_sales VALUES (106, 'Dining Table','Furniture', 28000, '2024-06-20');


select * from store_a_sales;
select * from store_b_sales;


select category,product_name,total_revenue from (
select category,product_name, sum(revenue) as total_revenue, dense_rank() over(partition by category order by sum(revenue)  desc) as rnk from(
select category, product_name, revenue from store_a_sales
union all
select category, product_name, revenue from store_b_sales) t
group by category, product_name) ranked 
where rnk <=2


-------============Problem 12 ============================================


--Scenario: The HR team wants to display the candidate list in an alternating gender order — Male, Female, Male, Female... 
--sorted by score descending within each gender. They want:

--Candidate name, Gender, Score, Arranged alternating Male → Female → Male → Female

CREATE TABLE candidates (
    candidate_id INT PRIMARY KEY,
    candidate_name VARCHAR(100),
    gender VARCHAR(10),
    score INT
);

INSERT INTO candidates VALUES (1,  'Amit',    'Male',   88);
INSERT INTO candidates VALUES (2,  'Priya',   'Female', 92);
INSERT INTO candidates VALUES (3,  'Rahul',   'Male',   76);
INSERT INTO candidates VALUES (4,  'Sneha',   'Female', 85);
INSERT INTO candidates VALUES (5,  'Kiran',   'Male',   91);
INSERT INTO candidates VALUES (6,  'Meera',   'Female', 78);
INSERT INTO candidates VALUES (7,  'Vikram',  'Male',   83);
INSERT INTO candidates VALUES (8,  'Divya',   'Female', 95);
INSERT INTO candidates VALUES (9,  'Suresh',  'Male',   79);
INSERT INTO candidates VALUES (10, 'Anjali',  'Female', 88);



select * from candidates;
select candidate_name, gender, score , rnk from (
select candidate_name, gender, score, row_number() over(order by score desc) as rnk from candidates where gender = 'Male'
union all 
select candidate_name, gender, score, row_number() over(order by score desc) as rnk from candidates where gender = 'Female'
)t
order by rnk, gender desc


-------============Problem 13 ============================================

/*Scenario: The finance team wants to see a running total of revenue per region ordered by sale date — so they can see how revenue accumulated over time within each region across both quarters.
They want:

Sale date
Region
Sales rep
Amount
Running total within each region ordered by sale date*/

CREATE TABLE region_sales_q1 (
    sale_id INT PRIMARY KEY,
    sales_rep VARCHAR(100),
    region VARCHAR(50),
    amount DECIMAL(10,2),
    sale_date DATE
);

CREATE TABLE region_sales_q2 (
    sale_id INT PRIMARY KEY,
    sales_rep VARCHAR(100),
    region VARCHAR(50),
    amount DECIMAL(10,2),
    sale_date DATE
);

INSERT INTO region_sales_q1 VALUES (1, 'Amit',  'North', 45000, '2024-01-10');
INSERT INTO region_sales_q1 VALUES (2, 'Priya', 'South', 30000, '2024-02-15');
INSERT INTO region_sales_q1 VALUES (3, 'Rahul', 'North', 28000, '2024-03-05');
INSERT INTO region_sales_q1 VALUES (4, 'Sneha', 'South', 52000, '2024-03-20');
INSERT INTO region_sales_q1 VALUES (5, 'Kiran', 'North', 38000, '2024-03-25');

INSERT INTO region_sales_q2 VALUES (101, 'Amit',  'North', 55000, '2024-04-10');
INSERT INTO region_sales_q2 VALUES (102, 'Priya', 'South', 48000, '2024-05-15');
INSERT INTO region_sales_q2 VALUES (103, 'Rahul', 'North', 50000, '2024-06-05');
INSERT INTO region_sales_q2 VALUES (104, 'Sneha', 'South', 25000, '2024-06-01');
INSERT INTO region_sales_q2 VALUES (105, 'Kiran', 'North', 42000, '2024-06-15');



select * from region_sales_q1;
select * from region_sales_q2;

with combined as(
select  region, sales_rep,sale_date, amount from region_sales_q1
union all 
select  region, sales_rep, sale_date, amount from region_sales_q2)
select * , sum(amount) over(partition by region order by sale_date) as running_total from combined


-------============Problem 14 ============================================

/*
Scenario: Flipkart wants to classify customers into loyalty tiers based on their total spending across both halves of 2024:
Total SpendTier>= 100000'Platinum'>= 50000'Gold'>= 20000'Silver'< 20000'Bronze'
They want:

Customer name
Total spend
Their loyalty tier
Sorted by total spend descending
*/
CREATE TABLE first_half_purchases (
    purchase_id INT PRIMARY KEY,
    customer_id INT,
    customer_name VARCHAR(100),
    amount DECIMAL(10,2),
    purchase_date DATE
);

CREATE TABLE second_half_purchases (
    purchase_id INT PRIMARY KEY,
    customer_id INT,
    customer_name VARCHAR(100),
    amount DECIMAL(10,2),
    purchase_date DATE
);

INSERT INTO first_half_purchases VALUES (1, 101, 'Ravi',   45000, '2024-01-10');
INSERT INTO first_half_purchases VALUES (2, 102, 'Sneha',  80000, '2024-02-15');
INSERT INTO first_half_purchases VALUES (3, 103, 'Kiran',  12000, '2024-03-05');
INSERT INTO first_half_purchases VALUES (4, 104, 'Meera',  30000, '2024-04-20');
INSERT INTO first_half_purchases VALUES (5, 105, 'Arjun',  8000,  '2024-05-18');

INSERT INTO second_half_purchases VALUES (101, 101, 'Ravi',   62000, '2024-07-10');
INSERT INTO second_half_purchases VALUES (102, 102, 'Sneha',  40000, '2024-08-15');
INSERT INTO second_half_purchases VALUES (103, 103, 'Kiran',  18000, '2024-09-05');
INSERT INTO second_half_purchases VALUES (104, 104, 'Meera',  25000, '2024-10-20');
INSERT INTO second_half_purchases VALUES (105, 105, 'Arjun',  15000, '2024-11-18');



select * from first_half_purchases;
select * from second_half_purchases;

select customer_name, sum(amount) as total_spend, 
case when sum(amount) >= 100000 then 'Platinum'
	when sum(amount) >= 50000 then 'Gold'
	when sum(amount) >= 20000 then 'Silver'
	else 'Bronze'
	end as 'Total SpendTier' from (
select customer_name, amount from first_half_purchases
union all 
select customer_name, amount from second_half_purchases) t
group by customer_name 
order by total_spend


-------============Problem 15 ============================================
/*Scenario: The business analytics team wants to see month over month revenue growth across both online and offline channels combined for 2024. They want:

Month number
Month name
Total revenue that month
Previous month revenue
Growth amount (current month - previous month)
Growth % rounded to 2 decimal places*/

CREATE TABLE online_revenue (
    sale_id INT PRIMARY KEY,
    product VARCHAR(100),
    amount DECIMAL(10,2),
    sale_date DATE
);

CREATE TABLE offline_revenue (
    sale_id INT PRIMARY KEY,
    product VARCHAR(100),
    amount DECIMAL(10,2),
    sale_date DATE
);

INSERT INTO online_revenue VALUES (1,  'Laptop',  45000, '2024-01-10');
INSERT INTO online_revenue VALUES (2,  'Phone',   30000, '2024-02-15');
INSERT INTO online_revenue VALUES (3,  'Laptop',  52000, '2024-02-20');
INSERT INTO online_revenue VALUES (4,  'TV',      38000, '2024-03-05');
INSERT INTO online_revenue VALUES (5,  'Phone',   41000, '2024-03-18');
INSERT INTO online_revenue VALUES (6,  'Laptop',  60000, '2024-04-10');
INSERT INTO online_revenue VALUES (7,  'Phone',   35000, '2024-05-15');
INSERT INTO online_revenue VALUES (8,  'TV',      48000, '2024-05-22');
INSERT INTO online_revenue VALUES (9,  'Laptop',  70000, '2024-06-01');
INSERT INTO online_revenue VALUES (10, 'Phone',   42000, '2024-06-18');

INSERT INTO offline_revenue VALUES (101, 'Laptop',  38000, '2024-01-15');
INSERT INTO offline_revenue VALUES (102, 'TV',      55000, '2024-02-10');
INSERT INTO offline_revenue VALUES (103, 'Phone',   28000, '2024-03-22');
INSERT INTO offline_revenue VALUES (104, 'Laptop',  45000, '2024-04-05');
INSERT INTO offline_revenue VALUES (105, 'TV',      62000, '2024-04-25');
INSERT INTO offline_revenue VALUES (106, 'Phone',   33000, '2024-05-10');
INSERT INTO offline_revenue VALUES (107, 'Laptop',  51000, '2024-06-08');
INSERT INTO offline_revenue VALUES (108, 'TV',      40000, '2024-06-22');





select * from online_revenue;
select * from offline_revenue;

with combined as(
	select sale_date, amount from online_revenue
	union all
	select sale_date, amount  from offline_revenue),
grouped as (
	select month(sale_date) as month_num, datename(month, sale_date) as month_name, sum(amount) as total_revenue
	from combined
	group by month(sale_date), datename(month, sale_date)),
prev_rvn as(
select  month_num, month_name, total_revenue, lag(total_revenue)  over(order by month_num ) as prev_revenue,
(total_revenue-lag(total_revenue)  over(order by month_num )) as growth_amount from grouped )
select month_num, month_name, total_revenue,
	   ISNULL(prev_revenue, 0) AS prev_revenue,
       ISNULL(growth_amount, 0) AS growth_amount,
       ISNULL(ROUND((growth_amount * 100.0) / prev_revenue, 2), 0) AS growth_pct
FROM prev_rvn
ORDER BY month_num














