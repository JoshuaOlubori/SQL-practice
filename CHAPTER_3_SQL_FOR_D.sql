--              CHAPTER 3: SQL FOR DATA PREPARATION
--Learning Objectives
--By the end of this chapter, you will be able to:
--• Assemble multiple tables and queries together into a dataset
--• Transform and clean data using SQL functions
--• Remove duplicate data using DISTINCT and DISTINCT ON

--Activity 5: Building a Sales Model Using SQL Techniques
--The aim of this activity is to clean and prepare our data for analysis using SQL
--techniques. The data science team wants to build a new model to help predict which
--customers are the best prospects for remarketing. A new data scientist has joined their
--team and does not know the database well enough to pull a dataset for this new model.
--The responsibility has fallen to you to help the new data scientist prepare and build a
--dataset to be used to train a model. Write a query to assemble a dataset that will do the
--following:

--2. Use INNER JOIN to join the customers table to the sales table
SELECT c.*, p.*, COALESCE(s.dealership_id, -1),
CASE WHEN p.base_msrp - s.sales_amount > 500 THEN 1
ELSE 0
END AS high_savings
FROM customers c INNER JOIN sales s
ON c.customer_id = s.customer_id
INNER JOIN products p
ON p.product_id = s.product_id
LEFT JOIN dealerships d
ON d.dealership_id = s.dealership_id