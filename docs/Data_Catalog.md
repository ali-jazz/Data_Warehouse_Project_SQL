# Data Dictionary

## Overview
These tables represent the business-level data model designed to support analytical and reporting use cases.  
The model follows a **star schema**, consisting of **dimension tables** and a **fact table**.


---
## dim_customer
- **Purpose:** Stores customer details enriched with demographic and geographic data.
  
| Column | Data Type | Description |
|---|---|---|
| cst_id | int | Unique customer identifier from the CRM system. |
| cst_key | varchar(50) | Customer business key used to link CRM and ERP customer records. |
| cst_fullname | varchar(101) | Full customer name created by combining first name and last name. |
| cst_marital_status | varchar(7) | Standardized marital status of the customer. |
| cst_gndr | varchar(6) | Standardized customer gender. CRM is used as the main source, with ERP used when CRM gender is missing or unavailable. |
| cst_age | bigint | Customer age calculated from ERP birth date. |
| cntry | varchar(50) | Customer country from ERP location data. |

---

## fact_sales
- **Purpose:** Stores transactional sales data used for business analysis.

| Column | Data Type | Description |
|---|---|---|
| sls_ord_num | varchar(50) | Sales order number. |
| sls_prd_key | varchar(50) | Product key used to link sales transactions to `dim_product.prd_key`. |
| sls_cust_id | INT | Customer ID used to link sales transactions to `dim_customer.cst_id`. |
| sls_order_dt | DATE | Order date. |
| sls_ship_dt | DATE | Shipping date. |
| sls_due_dt | DATE | Due date. |
| sls_quantity | INT | Quantity of units sold. |
| sls_price | INT | Unit sale price. |
| sls_sales | BIGINT | Total sales amount for the transaction, calculated as quantity × price. |

---

## dim_product
- **Purpose:** Stores product attributes and category hierarchy for analysis.
  
| Column | Data Type | Description |
|---|---|---|
| prd_key | varchar(50) | Unique product key used to link product information to sales transactions. |
| cat_id | varchar(7) | Product category identifier extracted from the CRM product key. |
| prd_nm | varchar(50) | Product name. |
| prd_cost | varchar(50) | Product cost. |
| prd_line | varchar(11) | Standardized product line. |
| cat | varchar(50) | Product category. |
| subcat | varchar(50) | Product subcategory. |
| maintenance | varchar(50) | Maintenance category or maintenance flag associated with the product. |
| prd_start_dt | DATE | Product start date. |
| prd_end_dt | DATE | Product end date. Null values indicate active products. |
| product_status | varchar(8) | Product status, classified as Active, Inactive, or Unknown. |
