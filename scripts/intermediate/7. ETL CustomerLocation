/*
=======================================================================
Create Intermediate Table - ERP Location Information
=======================================================================
Script Purpose:
    This script creates a cleaned intermediate ERP location table from
    the raw ERP location staging table.

    The purpose of this transformation is to:
    - Load raw customer location data
    - Validate customer ID formatting
    - Remove special characters from customer IDs
    - Standardize country values
    - Convert empty country values to NULL

Source Table:
    staging_erp_loc_a101

Output Table:
    inter_erp_loc_a101_clean

Notes:
    - Customer IDs are standardized by removing hyphens.
    - Country codes are mapped to full country names.
=======================================================================
*/

-- Step 1: Load raw ERP location data
DROP TABLE IF EXISTS inter_erp_loc_a101;

CREATE TABLE inter_erp_loc_a101 AS
SELECT
    *,
    NOW() AS dwh_create_date
FROM staging_erp_loc_a101;


-- Step 2: Check customer IDs without expected hyphen format
SELECT
    cid
FROM inter_erp_loc_a101
WHERE cid NOT LIKE '%-%';


-- Step 3: Review distinct country values
SELECT DISTINCT
    cntry
FROM inter_erp_loc_a101;


-- Step 4: Create cleaned ERP location table
DROP TABLE IF EXISTS inter_erp_loc_a101_clean;

CREATE TABLE inter_erp_loc_a101_clean AS
SELECT
    REPLACE(TRIM(cid), '-', '') AS cid,

    CASE 
        WHEN UPPER(TRIM(cntry)) IN ('US', 'USA') THEN 'United States'
        WHEN UPPER(TRIM(cntry)) = 'DE' THEN 'Germany'
        WHEN TRIM(cntry) = '' THEN NULL
        ELSE TRIM(cntry)
    END AS cntry

FROM inter_erp_loc_a101;
