/*
=======================================================================
Create Dimension Table - Product & Category Analysis
=======================================================================
Script Purpose:
    This script creates the product dimension table by combining CRM
    product data with ERP category information, while ensuring a unique
    product key and full coverage of all products referenced in sales data.

    The goal is to:
    - Create a product dimension table for analytical reporting
    - Combine product attributes with category hierarchy
    - Ensure one unique record per product (no duplicates)
    - Prioritize active products when multiple records exist
    - Include all products referenced in fact_sales
    - Analyze product distribution and pricing across categories

Source Tables:
    - inter_crm_prd_info_clean (product information)
    - inter_erp_px_cat_g1v2_clean (category hierarchy)
    - fact_sales (sales transactions)

Output Table:
    - dim_product

Notes:
    - Product keys are standardized using SUBSTRING() to match fact_sales
    - ROW_NUMBER() is used to deduplicate products and keep a single record per prd_key
    - When multiple records exist, active products are prioritized, otherwise the most recent record is selected
    - A product_status flag is created to distinguish active vs inactive products
    - Products present in fact_sales but missing from CRM data are added as "Unknown Product"
    - This ensures referential integrity between fact_sales and dim_product
    - Category mapping is performed using cat_id
=======================================================================
*/

USE datawarehouse;

-- Step 1: Create product-category analytical table
DROP TABLE IF EXISTS dim_product;

CREATE TABLE dim_product AS

SELECT 
    prd_key,
    cat_id,
    prd_nm,
    prd_cost,
    prd_line,
    cat,
    subcat,
    maintenance,
    prd_start_dt,
    prd_end_dt,
    product_status
FROM (
    SELECT 
        SUBSTRING(i.prd_key, 7) AS prd_key,
        i.cat_id,
        i.prd_nm,
        i.prd_cost,
        i.prd_line,
        ct.cat,
        ct.subcat,
        ct.maintenance,
        i.prd_start_dt,
        i.prd_end_dt,
        CASE 
            WHEN i.prd_end_dt IS NULL THEN 'Active'
            ELSE 'Inactive'
        END AS product_status,
        ROW_NUMBER() OVER (
            PARTITION BY SUBSTRING(i.prd_key, 7)
            ORDER BY 
                (i.prd_end_dt IS NULL) DESC,
                i.prd_start_dt DESC
        ) AS rn
    FROM inter_crm_prd_info_clean AS i
    LEFT JOIN inter_erp_px_cat_g1v2_clean AS ct
        ON i.cat_id = ct.id
) t
WHERE rn = 1

UNION ALL

SELECT DISTINCT
    f.sls_prd_key AS prd_key,
    'Unknown' AS cat_id,
    'Unknown Product' AS prd_nm,
    NULL AS prd_cost,
    'Unknown' AS prd_line,
    'Unknown' AS cat,
    'Unknown' AS subcat,
    'Unknown' AS maintenance,
    NULL AS prd_start_dt,
    NULL AS prd_end_dt,
    'Unknown' AS product_status
FROM fact_sales AS f
LEFT JOIN inter_crm_prd_info_clean AS i
    ON f.sls_prd_key = SUBSTRING(i.prd_key, 7)
WHERE i.prd_key IS NULL;

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
