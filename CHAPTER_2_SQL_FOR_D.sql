--              CHAPTER 2: The Basics of SQL for
--                                Analytics

--Activity 3: Querying the customers Table Using Basic Keywords in a SELECT
--Query
--One day, your manager at ZoomZoom calls you in and tells you that the marketing
--department has decided that they want to do a series of marketing campaigns to help
--promote a sale. You will need to send queries to the manager to pull the data. The
--following are the steps to complete the activity:
--1. Open your favorite SQL client and connect to the sqlda database. Examine the
--schema for the customers table from the schema dropdown.


--2. Write a query that pulls all emails for ZoomZoom customers in the state of Florida
--in alphabetical order.
SELECT email
FROM customers
WHERE state = 'FL'
ORDER BY state;

--3. Write a query that pulls all the first names, last names and email details for
--ZoomZoom customers in New York City in the state of New York. They should be
--ordered alphabetically by the last name followed by the first name.
SELECT c.first_name, c.last_name, e.email_id, e.email_subject
FROM customers c INNER JOIN emails e
ON c.customer_id = e.customer_id
WHERE state = 'NY' AND city = 'New York City'
ORDER BY 2, 1;

--4. Write a query that returns all customers with a phone number ordered by the date
--the customer was added to the database.

SELECT first_name || ' ' || last_name AS customer, phone
FROM customers
WHERE phone IS NOT NULL
ORDER BY date_added;

--Activity 4: Marketing Operations
--You did a great job pulling data for the marketing team. However, the marketing
--manager, who you so graciously helped, realized that they had made a mistake. It
--turns out that instead of just the query, the manager needs to create a new table in the
--company's analytics database. Furthermore, they need to make some changes to the
--data that is present in the customers table. It is your job to help the marketing manager
--with the table:

--1. Create a new table called customers_nyc that pulls all rows from the customers
--table where the customer lives in New York City in the state of New York
CREATE TABLE customers_nyc AS
(SELECT * FROM customers
WHERE city = 'New York City' AND state = 'NY')

--2. Delete from the new table all customers in postal code 10014. Due to local laws,
--they will not be eligible for marketing.
DELETE FROM customers_nyc
WHERE postal_code = '10014';

--3. Add a new text column called event.
ALTER TABLE customers_nyc
ADD COLUMN event text;

--4. Set the value of the event to thank-you party
UPDATE customers_nyc
SET event = 'thank-you party'

--5.  The marketing manager thanks you and then asks you to delete the customers_nyc table.
DROP TABLE customers_nyc;
