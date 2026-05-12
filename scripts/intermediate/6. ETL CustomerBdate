/*
=======================================================================
Create Intermediate Table - ERP Customer Information
=======================================================================
Script Purpose:
    This script creates a cleaned intermediate ERP customer table from
    the raw staging data.

    The purpose of this transformation is to:
    - Load raw ERP customer data
    - Identify duplicate customer IDs
    - Standardize customer IDs by removing prefixes
    - Handle invalid birth dates (future dates)
    - Standardize gender values

Source Table:
    staging_erp_cust_az12

Output Table:
    inter_erp_cust_az12_clean

Notes:
    - Customer IDs starting with 'NAS' are cleaned by removing the prefix
    - Future birth dates are considered invalid and replaced with NULL
    - Gender values are standardized to 'Male' and 'Female'
=======================================================================
*/

-- Step 1: Load raw ERP customer data
DROP TABLE IF EXISTS inter_erp_cust_az12;

CREATE TABLE inter_erp_cust_az12 AS
SELECT
    *,
    NOW() AS dwh_create_date
FROM staging_erp_cust_az12;


-- Step 2: Check for duplicate customer IDs
SELECT
    cid,
    COUNT(*) AS duplicate_count
FROM inter_erp_cust_az12
GROUP BY cid
HAVING COUNT(*) > 1;


-- Step 3: Review distinct gender values
SELECT DISTINCT
    gen
FROM inter_erp_cust_az12;


-- Step 4: Identify invalid future birth dates
SELECT
    bdate
FROM inter_erp_cust_az12
WHERE bdate >= CURDATE();


-- Step 5: Review birth date distribution
SELECT
    bdate
FROM inter_erp_cust_az12
ORDER BY bdate;


-- Step 6: Create cleaned ERP customer table
DROP TABLE IF EXISTS inter_erp_cust_az12_clean;

CREATE TABLE inter_erp_cust_az12_clean AS
SELECT
    CASE 
        WHEN TRIM(cid) LIKE 'NAS%' THEN SUBSTRING(TRIM(cid), 4)
        ELSE TRIM(cid)
    END AS cid,

    IF(bdate >= CURDATE(), NULL, bdate) AS bdate,

    CASE 
        WHEN UPPER(SUBSTRING(TRIM(gen), 1, 1)) = 'M' THEN 'Male'
        WHEN UPPER(SUBSTRING(TRIM(gen), 1, 1)) = 'F' THEN 'Female'
        ELSE NULL
    END AS gen

FROM inter_erp_cust_az12;
