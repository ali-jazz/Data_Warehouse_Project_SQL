/*
=======================================================================
Create Analytical Table - Customer Orders & Sales Analysis
=======================================================================
Script Purpose:
    This script creates an analytical table combining customer and sales
    data, and performs business analysis on customer segments.

    The goal is to:
    - Combine sales transactions with customer attributes
    - Analyze revenue distribution across customer segments
    - Identify top-performing customers

Source Tables:
    - inter_crm_sales_details_clean (sales transactions)
    - dim_customer (customer demographic information)

Output Table:
    - cust_order

=======================================================================
*/

USE datawarehouse;

-- Step 1: Create sale fact table
DROP TABLE IF EXISTS fact_sales;
CREATE TABLE fact_sales AS
SELECT 
sls_ord_num,
sls_prd_key,
sls_cust_id,
sls_order_dt,
sls_ship_dt,
sls_due_dt,
sls_quantity,
sls_price,
sls_sales
FROM inter_crm_sales_details_clean; 

-- Step 2: Create customer-order analytical table
DROP TABLE IF EXISTS cust_order;

CREATE TABLE cust_order AS
SELECT 
    s.sls_cust_id,
    s.sls_quantity,
    s.sls_price,
    s.sls_sales,
    s.sls_prd_key,
    c.cst_fullname,
    c.cst_marital_status,
    c.cst_gndr,
    c.cst_age,
    c.cntry
FROM fact_sales AS s
LEFT JOIN dim_customer AS c
    ON s.sls_cust_id = c.cst_id;


-- Step 3: Sales distribution by gender
SELECT
    cst_gndr,
    SUM(sls_sales) AS total_sales,
    ROUND(
        SUM(sls_sales) * 100.0 / 
        (SELECT SUM(sls_sales) FROM cust_order), 
    2) AS percentage_sales
FROM cust_order
GROUP BY cst_gndr;


-- Step 4: Sales distribution by marital status
SELECT
    cst_marital_status,
    SUM(sls_sales) AS total_sales,
    ROUND(
        SUM(sls_sales) * 100.0 / 
        (SELECT SUM(sls_sales) FROM cust_order), 
    2) AS percentage_sales
FROM cust_order
GROUP BY cst_marital_status;


-- Step 5: Sales distribution by gender and marital status
SELECT
    cst_marital_status,
    cst_gndr,
    SUM(sls_sales) AS total_sales,
    ROUND(
        SUM(sls_sales) * 100.0 / 
        (SELECT SUM(sls_sales) FROM cust_order), 
    2) AS percentage_sales
FROM cust_order
GROUP BY cst_marital_status, cst_gndr;


-- Step 6: Top 10 customers by total revenue
SELECT
    sls_cust_id,
    cst_fullname,
    SUM(sls_sales) AS total_sales,
    SUM(sls_quantity) AS total_units
FROM cust_order
GROUP BY sls_cust_id, cst_fullname
ORDER BY total_sales DESC
LIMIT 10;
