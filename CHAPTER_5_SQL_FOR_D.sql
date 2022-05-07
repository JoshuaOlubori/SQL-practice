--                          CHAPTER 5
--              WINDOW FUNCTIONS FOR DATA ANALYSIS
--Learning Objectives
--By the end of this chapter, you will be able to:
--• Explain what a window function is
--• Write basic window functions
--• Use common window functions to calculate statistics
--• Analyze sales data using window functions and a window frame

----Exercise 16: Analyzing Customer Data Fill Rates over Time
--For the last 6 months, ZoomZoom has been experimenting with various features in
--order to encourage people to fill out all fields on the customer form, especially their
--address. To analyze this data, the company would like a running total of how many
--users have filled in their street address over time. Write a query to produce these
--results

--2. Use window functions and write a query that will return customer information
--and how many people have filled out their street address. Also, order the list as per
--the date. The query would look like:
SELECT customer_id, first_name || ' ' || last_name AS name, date_added::DATE,
COUNT(CASE WHEN street_address is not null then 1 else null end) OVER (ORDER BY date_added::DATE)
AS total_customer_filled_sad
FROM customers
ORDER BY date_added

--3. Exercise 17: Rank Order of Hiring
--ZoomZoom would like to promote salespeople at their regional dealerships to
--management and would like to consider tenure in their decision. Write a query that will
--rank the order of users according to their hire date for each dealership:
--1. Open your favorite SQL client and connect to the sqlda database.
--2. Calculate a rank for every salesperson, with a rank of 1 going to the first hire, 2 to
--the second hire, and so on, using the RANK() function:

SELECT username, hire_date,
        dealership_id, RANK() OVER (PARTITION BY dealership_id ORDER BY hire_date)
FROM salespeople
WHERE termination_date IS NULL;

--Exercise 18: Team Lunch Motivation
--To help improve sales performance, the sales team has decided to buy lunch for all
--salespeople at the company every time they beat the figure for best daily total earnings
--achieved over the last 30 days. Write a query that produces the total sales in dollars
--for a given day and the target the salespeople have to beat for that day, starting from
--January 1, 2019:
WITH daily_sales as (
SELECT sales_transaction_date::DATE, --always remember to format to date
SUM(sales_amount) as total_sales
FROM sales
GROUP BY 1
),
sales_stats_30 AS (
SELECT sales_transaction_date, total_sales,
MAX(total_sales) OVER (ORDER BY sales_transaction_date ROWS BETWEEN 30
PRECEDING and 1 PRECEDING)
AS max_sales_30
FROM daily_sales
ORDER BY 1)

SELECT *
FROM sales_stats_30
WHERE sales_transaction_date>='2019-01-01';

--Activity 7: Analyzing Sales Using Window Frames and Window Functions
--It's the holidays, and it's time to give out Christmas bonuses at ZoomZoom. Sales
--team want to see how the company has performed overall, as well as how individual
--dealerships have performed within the company. To achieve this, ZoomZoom's head of
--Sales would like you to run an analysis for them:
--1. Open your favorite SQL client and connect to the sqlda database.


--2. Calculate the total sales amount by day for all of the days in the year 2018 (that is,
--before the date January 1, 2019).
SELECT sales_transaction_date::DATE,
SUM(sales_amount) as total_sales_amount
FROM sales
WHERE sales_transaction_date>='2018-01-01'
AND sales_transaction_date<'2019-01-01'
GROUP BY 1
ORDER BY 1;

--3. Calculate the rolling 30-day average for the daily number of sales deals.
WITH daily_deals as (
SELECT sales_transaction_date::DATE,
COUNT(*) as total_deals
FROM sales
GROUP BY 1
),

moving_average_calculation_30 AS (
SELECT sales_transaction_date, total_deals,
AVG(total_deals) OVER (ORDER BY sales_transaction_date ROWS BETWEEN 30
PRECEDING and CURRENT ROW) AS deals_moving_average,
ROW_NUMBER() OVER (ORDER BY sales_transaction_date) as row_number
FROM daily_deals
ORDER BY 1)

SELECT sales_transaction_date,
(CASE WHEN row_number>=30 THEN deals_moving_average ELSE NULL END) AS deals_moving_average_30
FROM moving_average_calculation_30
WHERE sales_transaction_date>='2018-01-01'
AND sales_transaction_date<'2019-01-01';


--4. Calculate what decile each dealership  would be in compared to other dealerships
--based on their total sales amount.
WITH total_dealership_sales AS
(
SELECT dealership_id,
SUM(sales_amount) AS total_sales_amount
FROM sales
WHERE sales_transaction_date>='2018-01-01'
AND sales_transaction_date<'2019-01-01'
AND channel='dealership'
GROUP BY 1
)
SELECT *,
NTILE(10) OVER (ORDER BY total_sales_amount)
FROM total_dealership_sales;