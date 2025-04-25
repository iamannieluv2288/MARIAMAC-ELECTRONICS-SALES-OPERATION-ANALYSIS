--SOLVING REAL-TIME PROBLEMS USNG SQL--

--PROBLEM STATEMENT:
--TechNova Inc., a global electronics retailer, is facing challenges in sales performance, 
--inventory management, supplier efficiency, and customer purchasing behavior.
--The leadership team has hired you, a Data Analyst, to uncover actionable insights that will help optimize sales,
--supply chain efficiency, and customer retention strategies.
--Your task is to analyze real sales transactions and provide data-driven recommendations.

--QUESTIONS:
-- 1. Find the Top 5 Revenue-Generating Products Over the Last 6 Months
-- 2. Identify the Most Loyal Customers Who Have Placed More Than 10 Orders
-- 3. Find the Month With the Highest Sales Volume & Revenue
-- 4. Identify Suppliers With High Lead Times & Low Reliability Scores
-- 5. Find the Most Popular Payment Method for High-Value Orders (> $1,000)
-- 6. Detect Customers Who Have Placed Orders but Later Canceled the Same Product
-- 7. Find Out-of-Stock Products That Have Been Sold Recently
-- 8. Rank the Top 3 Most Efficient Suppliers Based on Lead Time & Reliability
-- 9. Identify Product Categories With the Highest Average Order Value
-- 10.Find Customers Who Have Spent the Most in a Single Transaction

-- Let's the tables needed for this task--

-- Creating Customer table --

CREATE TABLE Customers (
						customer_id text,
						customer_name varchar,
						City varchar,
						Country varchar
);

SELECT * FROM Customers


-- Creating Date table --

CREATE TABLE Date_Table (
						Date_id int,
						date  Date

);

SELECT * FROM Data_Table 


-- Creating Product table --

CREATE TABLE Products (
						Product_id text,
						Product_name varchar,
						Category varchar,
						Supplier_id text,
						price int

);

SELECT * FROM Products 


-- Creating Suppliers table --

CREATE TABLE Suppliers (
						Supplier_id text,
						Supplier_name varchar,
						Country varchar,
						Reliability_score int,
						Lead_Time_Days int

);


SELECT * FROM Suppliers 

-- Creating Facts Sales table --

CREATE TABLE Fact_Sales (
						Order_id text,
						Customer_id varchar,
						Order_date date,
						Product_id text,
						Quantity int,
						Unit_price int,
						Discount decimal,
						Total_Amount decimal,
						Status varchar,
						Payment_method varchar

);

SELECT * FROM Fact_Sales

-- Let's dive into the questions--
-- QUESTION 1: Find the Top 5 Revenue-Generating Products Over the Last 6 Months

SELECT products.product_name,  
SUM(fact_sales.Total_Amount) AS Total_Revenue FROM fact_sales 
JOIN Products 
ON fact_sales.product_id = Products.product_id
WHERE 
order_date >='2023-03-01' AND
order_date <='2023-08-31'
AND
fact_sales.status='Delivered'
GROUP BY product_name
ORDER BY Total_Revenue DESC
LIMIT 5;

--The top 5 revenue-generating products are: 
--1. Law Headphones
--2. Nothing Smartwatch
--3. Help Tablet
--4. Allow Tablet
--5. PM Tablet

-- QUESTION 2: Identify the Most Loyal Customers Who Have Placed More Than 10 Orders

SELECT Customers.customer_name, COUNT(Fact_sales.order_id) AS NumberofOrders FROM Fact_sales
LEFT JOIN Customers
ON Fact_sales.customer_id = Customers.customer_id
GROUP BY customer_name
HAVING COUNT(Customers.customer_id)>10
LIMIT 10;

-- We have over 60 customers who made more than 10 orders but it was limited it to 10.

-- QUESTION 3: Find the Month With the Highest Sales Volume & Revenue

SELECT d.date_id,  TO_CHAR(order_date, 'YYYY-MM') AS sales_month,
       COUNT(fact_sales.order_id) AS total_orders,
       SUM(fact_sales.total_amount) AS total_revenue
FROM fact_sales 
JOIN Date_Table AS d
ON 
fact_sales.order_date = d.date
WHERE fact_sales.status = 'Delivered'
GROUP BY sales_month,date_id
LIMIT 1;


-- QUESTION 4: Identify Suppliers With High Lead Times & Low Reliability Scores

SELECT supplier_name, lead_time_days, reliability_score
FROM suppliers
WHERE lead_time_days >8 AND
reliability_score <85;

-- QUESTION 5: Find the Most Popular Payment Method for High-Value Orders (> $1,000)

SELECT payment_method, COUNT(order_id) AS Most_Popular_Payment_Method
FROM Fact_sales
WHERE total_amount > 1000
GROUP BY payment_method
LIMIT 1;

-- The Most Popular Payment Method is 'Paypal'

-- QUESTION 6: Detect Customers Who Have Placed Orders but Later Canceled the Same Product

SELECT customers.customer_id, customers.customer_name, products.product_name,products.category,
fact_sales.status AS CanceledOrders FROM fact_sales
JOIN products
ON fact_sales.product_id = products.product_id
JOIN customers 
ON fact_sales.customer_id=customers.customer_id
WHERE status = 'Canceled'

-- QUESTION 7: Find Out-of-Stock Products That Have Been Sold Recently

SELECT DISTINCT products.product_id, products.product_name
FROM fact_sales AS Out_of_stocks
JOIN products 
ON Out_of_stocks.product_id = products.product_id
WHERE Out_of_stocks.quantity = 0
GROUP BY products.product_name,products.product_id ;

-- QUESTION 8: Rank the Top 3 Most Efficient Suppliers Based on Lead Time & Reliability

SELECT supplier_name, lead_time_days, reliability_score
FROM suppliers
ORDER BY  reliability_score DESC, Lead_Time_Days ASC
LIMIT 3;

--The most efficient suppliers by lead time and reliability are:
-- Phillips Davenport
-- Spencer Group
-- Baker Soto

-- QUESTION 9: Identify Product Categories With the Highest Average Order Value

SELECT Products.category, AVG(fact_sales.quantity * fact_sales.unit_price)AS Highest_Average_Order
FROM Fact_sales
JOIN products 
ON Fact_sales.product_id = products.product_id
GROUP BY Products.category
ORDER BY Highest_Average_Order DESC
LIMIT 3;

-- The product categories with the highest average oredr are:
-- 1. Tablet
-- 2. Laptop
-- 3. TV

-- QUESTION 10: Find Customers Who Have Spent the Most in a Single Transaction


SELECT DISTINCT customers.customer_name, MAX(Fact_sales.Total_Amount) AS Highest_Spent
FROM Fact_sales
JOIN customers
ON Fact_sales.customer_id = customers.customer_id
GROUP BY customers.customer_name
ORDER BY Highest_Spent DESC
LIMIT 5;




