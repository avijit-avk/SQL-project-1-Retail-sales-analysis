# Retail Sales SQL Analysis Project

## Overview

This project explores a retail sales dataset using SQL.
The goal is to perform **data cleaning, exploration, and business analysis** to extract meaningful insights from transactional sales data.

The project demonstrates practical SQL skills including:

* Data cleaning and preprocessing
* Data exploration
* Aggregations and filtering
* Window functions
* Business-focused analysis queries

---

# Database Setup

## Create Database

```sql
CREATE DATABASE sql_project_1;
```

## Create Table

```sql
DROP TABLE IF EXISTS retail_sales;

CREATE TABLE retail_sales (
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
);
```

---

# Data Cleaning

## Fix Column Name

```sql
ALTER TABLE retail_sales
RENAME COLUMN quantiy TO quantity;
```

---

## Check Dataset Size

```sql
SELECT COUNT(*) FROM retail_sales;
```

---

## Identify NULL Values

```sql
SELECT *
FROM retail_sales
WHERE (
    transactions_id IS NULL OR
    sale_date IS NULL OR
    sale_time IS NULL OR
    customer_id IS NULL OR
    gender IS NULL OR
    age IS NULL OR
    category IS NULL OR
    quantity IS NULL OR
    price_per_unit IS NULL OR
    cogs IS NULL OR
    total_sale IS NULL
);
```

---

## Handle Missing Age Values

Replace NULL ages with the **average age**.

```sql
UPDATE retail_sales
SET age = (
    SELECT avg_age FROM (
        SELECT ROUND(AVG(age)) AS avg_age
        FROM retail_sales
        WHERE age IS NOT NULL
    ) AS temp
)
WHERE age IS NULL;
```

---

## Remove Remaining Invalid Records

```sql
DELETE FROM retail_sales
WHERE (
    transactions_id IS NULL OR
    sale_date IS NULL OR
    sale_time IS NULL OR
    customer_id IS NULL OR
    gender IS NULL OR
    age IS NULL OR
    category IS NULL OR
    quantity IS NULL OR
    price_per_unit IS NULL OR
    cogs IS NULL OR
    total_sale IS NULL
);
```

---

# Data Exploration

## Total Sales Records

```sql
SELECT COUNT(*) AS total_sales
FROM retail_sales;
```

---

## Unique Customers

```sql
SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM retail_sales;
```

---

## Distinct Product Categories

```sql
SELECT DISTINCT category
FROM retail_sales;
```

---

# Business Analysis Queries

## Q1: Sales on a Specific Date

Retrieve all transactions on **2022-11-05**

```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

---

## Q2: Clothing Sales with Quantity > 3 in November 2022

```sql
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
AND quantity > 3
AND sale_date BETWEEN '2022-11-01' AND '2022-11-30';
```

---

## Q3: Total Sales by Category

```sql
SELECT
    category,
    SUM(total_sale) AS total_sales,
    COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;
```

---

## Q4: Average Age of Customers Buying Beauty Products

```sql
SELECT
    category,
    ROUND(AVG(age),2) AS avg_customer_age
FROM retail_sales
WHERE category = 'Beauty'
GROUP BY category;
```

---

## Q5: Transactions with Sales Greater than 1000

```sql
SELECT *
FROM retail_sales
WHERE total_sale > 1000;
```

---

## Q6: Transactions by Gender and Category

```sql
SELECT
    category,
    gender,
    COUNT(transactions_id) AS transaction_count
FROM retail_sales
GROUP BY category, gender
ORDER BY category, gender;
```

---

## Q7: Best Selling Month in Each Year

```sql
SELECT
    years,
    months,
    sale_amount
FROM (
    SELECT
        DATE_FORMAT(sale_date,'%Y') AS years,
        DATE_FORMAT(sale_date,'%m') AS months,
        ROUND(AVG(total_sale),2) AS sale_amount,
        RANK() OVER (
            PARTITION BY DATE_FORMAT(sale_date,'%Y')
            ORDER BY ROUND(AVG(total_sale),2) DESC
        ) AS ranks
    FROM retail_sales
    GROUP BY years, months
) AS ranked_sales
WHERE ranks = 1;
```

---

## Q8: Top 5 Customers by Total Sales

```sql
SELECT
    customer_id,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;
```

---

## Q9: Unique Customers per Category

```sql
SELECT
    category,
    COUNT(DISTINCT customer_id) AS unique_customer_count
FROM retail_sales
GROUP BY category;
```

---

## Q10: Orders by Sales Shift

Shift Definition:

* Morning → before 12:00
* Afternoon → 12:00 to 17:00
* Evening → after 17:00

```sql
SELECT
    CASE
        WHEN HOUR(sale_time) < 12 THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    COUNT(*) AS total_orders
FROM retail_sales
GROUP BY shift;
```

---

# Key SQL Concepts Used

* Data Cleaning (`UPDATE`, `DELETE`)
* Aggregations (`SUM`, `AVG`, `COUNT`)
* Conditional Logic (`CASE`)
* Window Functions (`RANK`)
* Date Functions (`DATE_FORMAT`)
* Grouping and Filtering (`GROUP BY`, `HAVING`)

---

# Tools Used

* MySQL
* SQL for Data Analysis
* GitHub for version control and documentation

---

# Project Goal

This project demonstrates how SQL can be used to:

* Prepare raw data for analysis
* Extract insights from transactional datasets
* Solve business questions using structured queries

