/*
=======================================================================
Create Staging Tables
=======================================================================
Script Purpose:
    This script creates the staging tables used to store raw data from
    the CRM and ERP source systems.

Notes:
    - No transformations are applied at this stage.
    - Tables are loaded as-is from CSV files.
    - Data cleaning and type conversions will be handled in later layers.
    - Data was imported using MySQL Workbench Table Data Import Wizard.
=======================================================================
*/

-- CRM Customer Information
DROP TABLE IF EXISTS staging_crm_cust_info;
CREATE TABLE staging_crm_cust_info (
    cst_id INT,
    cst_key VARCHAR(50),
    cst_firstname VARCHAR(50),
    cst_lastname VARCHAR(50),
    cst_marital_status VARCHAR(50),
    cst_gndr VARCHAR(50),
    cst_create_date DATE
);

-- CRM Product Information
DROP TABLE IF EXISTS staging_crm_prd_info;
CREATE TABLE staging_crm_prd_info (
    prd_id INT,
    prd_key VARCHAR(50),
    prd_nm VARCHAR(50),
    prd_cost VARCHAR(50),
    prd_line VARCHAR(50),
    prd_start_dt DATE,
    prd_end_dt DATE
);

-- CRM Sales Details
DROP TABLE IF EXISTS staging_crm_sales_details;
CREATE TABLE staging_crm_sales_details (
    sls_ord_num VARCHAR(50),
    sls_prd_key VARCHAR(50),
    sls_cust_id INT,
    sls_order_dt INT,
    sls_ship_dt INT,
    sls_due_dt INT,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT
);

-- ERP Customer Information
DROP TABLE IF EXISTS staging_erp_cust_az12;
CREATE TABLE staging_erp_cust_az12 (
    cid VARCHAR(50),
    bdate DATE,
    gen VARCHAR(50)
);

-- ERP Location Information
DROP TABLE IF EXISTS staging_erp_loc_a101;
CREATE TABLE staging_erp_loc_a101 (
    cid VARCHAR(50),
    cntry VARCHAR(50)
);

-- ERP Product Category Information
DROP TABLE IF EXISTS staging_erp_px_cat_g1v2;
CREATE TABLE staging_erp_px_cat_g1v2 (
    id VARCHAR(50),
    cat VARCHAR(50),
    subcat VARCHAR(50),
    maintenance VARCHAR(50)
);
