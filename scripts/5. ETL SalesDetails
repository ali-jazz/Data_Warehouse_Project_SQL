/*
=======================================================================
Create Intermediate Table - CRM Sales Details
=======================================================================
Script Purpose:
    This script creates a cleaned intermediate sales table from the
    raw CRM sales staging table.

    The purpose of this transformation is to:
    - Load raw sales transaction data from the staging layer
    - Identify duplicate sales order numbers
    - Validate sales date fields
    - Convert integer date fields into proper DATE format
    - Trim text fields
    - Convert negative quantity and price values into positive values
    - Recalculate sales amount using quantity * price

Source Table:
    staging_crm_sales_details

Output Table:
    inter_crm_sales_details_clean

Notes:
    - Date fields are stored as integers in YYYYMMDD format in the source data.
    - Invalid dates or date values with incorrect length are converted to NULL.
    - Sales amount is recalculated to ensure consistency.
=======================================================================
*/

-- Step 1: Load raw CRM sales data into the intermediate layer
DROP TABLE IF EXISTS inter_crm_sales_details;

CREATE TABLE inter_crm_sales_details AS
SELECT
    *,
    NOW() AS dwh_create_date
FROM staging_crm_sales_details;


-- Step 2: Check for duplicate sales order numbers
SELECT
    sls_ord_num,
    COUNT(*) AS duplicate_count
FROM inter_crm_sales_details
GROUP BY sls_ord_num
HAVING COUNT(*) > 1;


-- Step 3: Review duplicate sales order records
SELECT
    *
FROM inter_crm_sales_details
WHERE sls_ord_num IN ( 
    SELECT sls_ord_num  
    FROM inter_crm_sales_details
    GROUP BY sls_ord_num
    HAVING COUNT(*) > 1
);


-- Step 4: Check invalid date formats
SELECT sls_ship_dt
FROM inter_crm_sales_details
WHERE LENGTH(sls_ship_dt) != 8;

SELECT sls_order_dt
FROM inter_crm_sales_details
WHERE LENGTH(sls_order_dt) != 8;

SELECT sls_due_dt
FROM inter_crm_sales_details
WHERE LENGTH(sls_due_dt) != 8;


-- Step 5: Review maximum date values
SELECT
    MAX(sls_ship_dt) AS max_ship_date,
    MAX(sls_due_dt) AS max_due_date,
    MAX(sls_order_dt) AS max_order_date
FROM inter_crm_sales_details;


-- Step 6: Check inconsistent sales values
SELECT
    sls_sales,
    sls_quantity,
    sls_price
FROM inter_crm_sales_details
WHERE sls_sales != sls_quantity * sls_price;


-- Step 7: Create final cleaned CRM sales table
DROP TABLE IF EXISTS inter_crm_sales_details_clean;

CREATE TABLE inter_crm_sales_details_clean AS
SELECT 
    TRIM(sls_ord_num) AS sls_ord_num,
    TRIM(sls_prd_key) AS sls_prd_key,
    sls_cust_id,

    CASE 
        WHEN sls_order_dt = 0 OR LENGTH(sls_order_dt) != 8 THEN NULL
        ELSE STR_TO_DATE(CAST(sls_order_dt AS CHAR), '%Y%m%d') 
    END AS sls_order_dt,

    CASE 
        WHEN sls_ship_dt = 0 OR LENGTH(sls_ship_dt) != 8 THEN NULL
        ELSE STR_TO_DATE(CAST(sls_ship_dt AS CHAR), '%Y%m%d') 
    END AS sls_ship_dt, 

    CASE 
        WHEN sls_due_dt = 0 OR LENGTH(sls_due_dt) != 8 THEN NULL
        ELSE STR_TO_DATE(CAST(sls_due_dt AS CHAR), '%Y%m%d') 
    END AS sls_due_dt,

    ABS(sls_quantity) AS sls_quantity,
    ABS(sls_price) AS sls_price,
    ABS(sls_price) * ABS(sls_quantity) AS sls_sales

FROM inter_crm_sales_details;
