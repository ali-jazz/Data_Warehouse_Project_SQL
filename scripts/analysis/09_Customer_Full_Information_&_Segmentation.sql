/*
=======================================================================
Create Analytical Table - Customer Full Information & Segmentation
=======================================================================
Script Purpose:
    This script builds a consolidated customer table by combining CRM
    and ERP data, and performs basic customer segmentation analysis.

    The goal is to:
    - Create a unified customer view (identity + demographics)
    - Enrich customers with age and country information
    - Reconcile gender information between CRM and ERP sources
    - Analyze customer distribution across key segments

Source Tables:
    - inter_crm_cust_info_clean (core customer info)
    - inter_erp_cust_az12_clean (demographics: birth date and gender)
    - inter_erp_loc_a101_clean (location: country)

Output Table:
    - dim_customer

Notes:
    - Customer age is calculated using birth date from ERP
    - Gender is primarily taken from CRM, but ERP gender is used when CRM gender is unavailable or marked as 'n/a'
    - LEFT JOIN is used to preserve all CRM customers
    - Missing demographic data may result in NULL values
=======================================================================
*/

USE datawarehouse;

-- Step 1: Create consolidated customer table
DROP TABLE IF EXISTS dim_customer;

CREATE TABLE dim_customer AS 
SELECT
    c.cst_id,
    c.cst_key,
    CONCAT(c.cst_firstname, ' ', c.cst_lastname) AS cst_fullname,
    c.cst_marital_status,
    CASE 
		WHEN b.gen = c.cst_gndr then b.gen
        WHEN c.cst_gndr = 'n/a' then b.gen
        else c.cst_gndr 
	END AS cst_gndr,
    TIMESTAMPDIFF(YEAR, b.bdate, CURDATE()) AS cst_age,
    l.cntry
FROM inter_crm_cust_info_clean AS c
LEFT JOIN inter_erp_cust_az12_clean AS b
    ON c.cst_key = b.cid
LEFT JOIN inter_erp_loc_a101_clean AS l
    ON c.cst_key = l.cid;
    

-- Step 2: Customer distribution by gender
SELECT
    cst_gndr,
    COUNT(*) AS customer_count,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM dim_customer),
    2) AS percentage_cust
FROM dim_customer
GROUP BY cst_gndr;


-- Step 3: Customer distribution by gender and marital status
SELECT
    cst_gndr,
    cst_marital_status,
    COUNT(*) AS customer_count,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM dim_customer),
    2) AS percentage_cust
FROM dim_customer
GROUP BY cst_gndr, cst_marital_status;


-- Step 4: Customer distribution by country
SELECT
    cntry,
    COUNT(*) AS customer_count,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM dim_customer),
    2) AS percentage_cust
FROM dim_customer
GROUP BY cntry;


-- Step 5: Customer distribution by age
SELECT 
    CASE
        WHEN cst_age IS NULL THEN 'Unknown'
        WHEN cst_age < 30 THEN '<30'
        WHEN cst_age >= 30 AND cst_age < 40 THEN '[30;40['
        WHEN cst_age >= 40 AND cst_age < 50 THEN '[40;50['
        WHEN cst_age >= 50 AND cst_age < 60 THEN '[50;60['
        WHEN cst_age >= 60 AND cst_age < 70 THEN '[60;70['
        WHEN cst_age >= 70 THEN '70+'
    END AS age_group,
    COUNT(*) AS customer_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM dim_customer), 2) AS customer_percentage
FROM dim_customer
GROUP BY age_group
ORDER BY customer_count DESC ;
