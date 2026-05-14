/*
=======================================================================
Create Intermediate Table - ERP Product Category Information
=======================================================================
Script Purpose:
    This script creates a cleaned intermediate ERP product category table
    from the raw staging data.

    The purpose of this transformation is to:
    - Load raw product category data
    - Review distinct category, subcategory, and maintenance values
    - Remove leading and trailing spaces from all fields
    - Standardize text fields for consistency

Source Table:
    staging_erp_px_cat_g1v2

Output Table:
    inter_erp_px_cat_g1v2_clean

Notes:
    - TRIM() is applied to all columns to remove unwanted spaces
    - This ensures consistent joins with other tables in later stages
=======================================================================
*/

-- Step 1: Load raw ERP product category data
DROP TABLE IF EXISTS inter_erp_px_cat_g1v2;

CREATE TABLE inter_erp_px_cat_g1v2 AS
SELECT
    *,
    NOW() AS dwh_create_date
FROM staging_erp_px_cat_g1v2;


-- Step 2: Review distinct values
SELECT DISTINCT cat
FROM inter_erp_px_cat_g1v2;

SELECT DISTINCT subcat
FROM inter_erp_px_cat_g1v2;

SELECT DISTINCT maintenance
FROM inter_erp_px_cat_g1v2;


-- Step 3: Create cleaned ERP product category table
DROP TABLE IF EXISTS inter_erp_px_cat_g1v2_clean;

CREATE TABLE inter_erp_px_cat_g1v2_clean AS 
SELECT
    TRIM(id) AS id,
    TRIM(cat) AS cat,
    TRIM(subcat) AS subcat,
    TRIM(maintenance) AS maintenance
FROM inter_erp_px_cat_g1v2;
