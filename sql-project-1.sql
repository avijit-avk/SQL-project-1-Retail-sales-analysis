create DATABASE sql_project_1;

DROP TABLE IF EXISTS retial_sales;
CREATE TABLE retail_sales
			(
				transactions_id INT PRIMARY KEY,
                sale_date DATE,
                sale_time TIME,
                customer_id INT,
                gender VARCHAR(20),
                age INT,
                category VARCHAR(50),
                quantiy FLOAT,
                price_per_unit FLOAT,
                cogs FLOAT,
                total_sale FLOAT
                )
;


-- Data Cleaning

ALTER TABLE retail_sales
RENAME COLUMN quantiy TO quantity;

SELECT COUNT(*) FROM retail_sales;

SELECT * FROM retail_sales;

-- Check in each column for null

SELECT * FROM retail_sales
WHERE( 
transactions_id IS NULL OR
sale_date IS NULL OR
sale_time IS NULL OR
customer_id IS NULL OR
gender IS NULL OR
age IS NULL OR
category IS NULL OR
quantiy IS NULL OR
price_per_unit IS NULL OR
cogs IS NULL OR 
total_sale IS NULL
);


SELECT * FROM retail_sales
WHERE age IS NULL;

SELECT COUNT(*) FROM retail_sales
WHERE age IS NULL;

-- Replacing Null values of age with the average age

UPDATE retail_sales
SET age = (
    SELECT avg_age FROM (
        SELECT ROUND(AVG(age)) AS avg_age 
        FROM retail_sales 
        WHERE age IS NOT NULL
    ) AS temp
)
WHERE age IS NULL;


SELECT * FROM retail_sales;

-- Removing the records for other null quantity, price-per-unit, cogs, total-sale, 679,746,1225

DELETE FROM retail_sales
WHERE( 
transactions_id IS NULL OR
sale_date IS NULL OR
sale_time IS NULL OR
customer_id IS NULL OR
gender IS NULL OR
age IS NULL OR
category IS NULL OR
quantiy IS NULL OR
price_per_unit IS NULL OR
cogs IS NULL OR 
total_sale IS NULL
);


SELECT * FROM retail_sales
WHERE transactions_id in (679,746,1225);



-- Data Exploration

SELECT * FROM retail_sales;

-- How many sales we have ?

SELECT COUNT(*) AS total_sales FROM retail_sales;

-- How many unique customers we have ?

SELECT COUNT(DISTINCT customer_id) AS total_customers FROM retail_sales;

-- How many distinct categories we have ?

SELECT COUNT(DISTINCT category) FROM retail_sales;

SELECT DISTINCT category FROM retail_sales;

-- Data Analysis and Business Key Problems

-- Q1. Query to retrieve all columns for sales made on'2022-11-05'

SELECT * FROM retail_sales
WHERE sale_date  = '2022-11-05';

-- Q2. Query to retrieve all transactions where the category is 'Clothing' and qunatity sold is more than 3 in the month of Nov-22

SELECT *
FROM retail_sales
WHERE category = 'Clothing'
AND sale_date BETWEEN '2022-11-01' AND '2022-11-30'
AND quantity > 3;

-- Q3. Query to calculate the total sales (total_sale) for each category

SELECT category, SUM(total_sale) total_sale, COUNT(*) total_orders FROM retail_sales
GROUP BY category;

-- Q4. Query to find the average age of customer who purchased items from 'Beauty' category

SELECT category,ROUND(AVG(age),2) AS Avg_customer_age FROM retail_sales
WHERE category = 'Beauty'
GROUP BY category ;

-- Q5. Query to find all transactions where total_sale is grater than 1000

SELECT * FROM retail_sales
WHERE total_sale > 1000;

-- Q6. Query to find total number of transactions(transacton_id) made by each gender in each category

SELECT category, gender, COUNT(transactions_id) AS transaction_count  FROM retail_sales
GROUP BY  category, gender
ORDER BY category, gender;

-- Q7. Query to calculate the average sale for each month. Find out the best selling month in each year

SELECT 
    *
FROM
    retail_sales;
    

SELECT 
	years,
    months,
    sale_amount
FROM 
	(SELECT 
		DATE_FORMAT(sale_date, '%Y') AS years,
		DATE_FORMAT(sale_date, '%m') AS months,
		ROUND(AVG(total_sale),2) AS sale_amount,
		RANK() OVER(PARTITION BY DATE_FORMAT(sale_date, '%Y') ORDER BY ROUND(AVG(total_sale),2) DESC) AS ranks
	FROM
		retail_sales
	GROUP BY  years, months) AS t1
WHERE ranks = 1;

-- Q8. query to find top 5 customers based on the highest total sales

SELECT customer_id, SUM(total_sale) AS total_sales FROM retail_sales
GROUP BY customer_id
order by total_sales DESC
limit 5;

-- Q9. Query to find the number of unique customers who purchased items from Each category

SELECT * FROM retail_sales;

SELECT 
    category,
    COUNT(DISTINCT customer_id) AS unique_customer_count
FROM
    retail_sales
GROUP BY category;

-- Q10. Query to create shift and number of orders (example : Morning < 12 , Afternoon Between 12 and 17 , Evening > 17)


SELECT * FROM retail_sales;

SELECT 
    COUNT(transactions_id) AS orders_count,
    CASE
        WHEN HOUR(sale_time) < 12 THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'AfterNoon'
        ELSE 'Evening'
    END AS shift
FROM
    retail_sales
GROUP BY shift;


WITH hourly_sales AS 
(
SELECT 
	CASE
        WHEN HOUR(sale_time) < 12 THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'AfterNoon'
        ELSE 'Evening'
    END AS shift
FROM retail_sales
)
SELECT shift, COUNT(*) AS total_orders
FROM hourly_sales
GROUP BY shift