/*
=======================================================================
Create Intermediate Table - CRM Customer Information
=======================================================================
Script Purpose:
    This script creates a cleaned intermediate customer table from the
    raw CRM customer staging table.

    The purpose of this transformation is to:
    - Load raw customer data from the staging layer
    - Identify duplicate and missing customer IDs
    - Keep the most recent customer record when duplicates exist
    - Trim leading and trailing spaces from customer names
    - Standardize marital status values
    - Standardize gender values
    - Prepare the customer data for the final analytical layer

Source Table:
    staging_crm_cust_info

Output Table:
    inter_crm_cust_info_clean

Notes:
    - Duplicate customers are resolved by keeping the record with the
      most recent cst_create_date.
    - Unknown or invalid gender/marital status values are mapped to 'n/a'.
=======================================================================
*/

-- Step 1: Load raw CRM customer data into the intermediate layer
DROP TABLE IF EXISTS inter_crm_cust_info;

CREATE TABLE inter_crm_cust_info AS
SELECT 
    *,
    NOW() AS dwh_create_date
FROM staging_crm_cust_info;


-- Step 2: Check for duplicate or missing customer IDs
SELECT 
    cst_id,
    COUNT(*) AS duplicate_count
FROM inter_crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 
   OR cst_id IS NULL;


-- Step 3: Review duplicate customer records
SELECT *
FROM inter_crm_cust_info
WHERE cst_id IN (
    SELECT cst_id
    FROM inter_crm_cust_info
    WHERE cst_id IS NOT NULL
    GROUP BY cst_id
    HAVING COUNT(*) > 1
)
OR cst_id IS NULL;


-- Step 4: Remove duplicates by keeping the most recent customer record
DROP TABLE IF EXISTS inter_crm_cust_info_nodup;

CREATE TABLE inter_crm_cust_info_nodup AS
SELECT *
FROM (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY cst_id 
            ORDER BY cst_create_date DESC
        ) AS row_num
    FROM inter_crm_cust_info
) t
WHERE row_num = 1;


-- Step 5: Check distinct gender and marital status values
SELECT DISTINCT cst_gndr
FROM inter_crm_cust_info_nodup;

SELECT DISTINCT cst_marital_status
FROM inter_crm_cust_info_nodup;


-- Step 6: Check for leading or trailing spaces in customer names
SELECT 
    cst_firstname,
    cst_lastname
FROM inter_crm_cust_info_nodup 
WHERE cst_firstname != TRIM(cst_firstname) 
   OR cst_lastname != TRIM(cst_lastname);


-- Step 7: Create final cleaned CRM customer table
DROP TABLE IF EXISTS inter_crm_cust_info_clean;

CREATE TABLE inter_crm_cust_info_clean AS
SELECT 
    cst_id,
    cst_key,
    TRIM(cst_firstname) AS cst_firstname,
    TRIM(cst_lastname) AS cst_lastname,

    CASE 
        WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
        WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
        ELSE 'n/a' 
    END AS cst_marital_status,

    CASE 
        WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
        WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
        ELSE 'n/a' 
    END AS cst_gndr,

    cst_create_date
FROM inter_crm_cust_info_nodup;

DROP TABLE IF EXISTS inter_crm_cust_info_nodup;
