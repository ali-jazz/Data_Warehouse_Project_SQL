/*
=======================================================================
Create Dimension Table - Product & Category Analysis
=======================================================================
Script Purpose:
    This script creates the product dimension table by combining CRM
    product data with ERP category information, and performs product
    distribution and pricing analysis.

    The goal is to:
    - Create a product dimension table for analytical reporting
    - Combine product attributes with category hierarchy
    - Keep only active products
    - Analyze product distribution and pricing across categories

Source Tables:
    - inter_crm_prd_info_clean (product information)
    - inter_erp_px_cat_g1v2_clean (category hierarchy)

Output Table:
    - dim_product

Notes:
    - Only active products are included (prd_end_dt IS NULL)
    - Category mapping is performed using cat_id
    - Product keys are extracted from the CRM product key using SUBSTRING()
=======================================================================
*/

USE datawarehouse;

-- Step 1: Create product-category analytical table
DROP TABLE IF EXISTS dim_product;

CREATE TABLE dim_product AS
SELECT 
    SUBSTRING(i.prd_key, 7) AS prd_key,
    i.cat_id,
    i.prd_nm,
    i.prd_cost,
    i.prd_line,
    ct.cat,
    ct.subcat,
    ct.maintenance
FROM inter_crm_prd_info_clean AS i
LEFT JOIN inter_erp_px_cat_g1v2_clean AS ct
    ON i.cat_id = ct.id
WHERE i.prd_end_dt IS NULL;


-- Step 2: Product distribution and pricing analysis
SELECT
    cat,
    subcat,
    prd_line,
    maintenance,
    COUNT(*) AS product_count,
    ROUND(AVG(prd_cost), 0) AS avg_cost,
    ROUND(MAX(prd_cost), 0) AS max_cost,
    ROUND(MIN(prd_cost), 0) AS min_cost
FROM dim_product
GROUP BY cat, subcat, prd_line, maintenance
ORDER BY product_count DESC;
