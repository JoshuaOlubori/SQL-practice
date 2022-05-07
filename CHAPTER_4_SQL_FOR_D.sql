--              CHAPTER 4:Aggregate Function for Data Analysis
--Learning Objectives
--By the end of this chapter, you will be able to:
--• Explain the conceptual logic of aggregation
--• Identify the common SQL aggregate functions
--• Use the GROUP BY clause to aggregate and combine groups of data for analysis
--• Use the HAVING clause to filter aggregates
--• Use aggregate functions to clean data and examine data quality

--2. Calculate the lowest, highest, average, and standard deviation price using the MIN,
--MAX, AVG, and STDDEV aggregate functions, respectively, from the products table and
--use GROUP BY to check the price of all the different product types: 
SELECT product_type,
    MIN(base_msrp),
    MAX(base_msrp),
    AVG(base_msrp),
    STDDEV(base_msrp)
    FROM products
    GROUP  BY 1;

--3. Grouping Sets
--Now, let's say you wanted to count the total number of customers you have in each
--state, while simultaneously, in the same aggregate functions, counting the total number
--of male and female customers you have in each state
    SELECT state, gender, COUNT(*)
FROM customers
GROUP BY GROUPING SETS (
(state),
(gender),
(state, gender)
)
ORDER BY 1, 2

SELECT percentile_cont(0.5) WITHIN GROUP (ORDER BY base_msrp)
FROM products;

--fraction of nulls within a COLUMN
SELECT SUM(CASE WHEN state IS NULL OR state IN ('') THEN 1 ELSE 0
END)::FLOAT/COUNT(*))
AS missing_state
FROM customers;

--check for uniqueness of column data
SELECT COUNT (DISTINCT customer_id)=COUNT(*) AS equal_ids
FROM customers;

--Activity 6: Analyzing Sales Data Using Aggregate Functions
--The goal of this activity is to analyze data using aggregate functions. The CEO, COO,
--and CFO of ZoomZoom would like to gain some insights on what might be driving sales.
--Now that the company feels they have a strong enough analytics team with your arrival.
--The task has been given to you, and your boss has politely let you know that this project
--is the most important project the analytics team has worked on:
--1. Open your favorite SQL client and connect to the sqlda database.


--2. Calculate the total number of unit sales the company has done.
SELECT COUNT(*)
FROM sales;

--3. Calculate the total sales amount in dollars for each state.
SELECT c.state, SUM(s.sales_amount) AS total_sales
FROM sales s INNER JOIN customers c
ON s.customer_id = c.customer_id
GROUP BY 1
ORDER BY 1

--4. Identify the top five best dealerships in terms of the most units sold (ignore
--internet sales).
SELECT dealership_id, COUNT(*)
FROM sales
WHERE channel <> 'internet'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

--5. Calculate the average sales amount for each channel, as seen in the sales table,
--and look at the average sales amount first by channel sales, then by product_id, and
--then by both together.
SELECT channel, product_id, AVG(sales_amount)
FROM sales
GROUP BY GROUPING SETS (
    (channel), (product_id), (channel, product_id)
)
order by 1,2