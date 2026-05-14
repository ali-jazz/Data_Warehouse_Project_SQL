# Data Dictionary

## dim_customer

| Column | Description |
|---|---|
| cst_id | Unique customer identifier from the CRM system. |
| cst_key | Customer business key used to link CRM and ERP customer records. |
| cst_fullname | Full customer name created by combining first name and last name. |
| cst_marital_status | Standardized marital status of the customer. |
| cst_gndr | Standardized customer gender. CRM is used as the main source, with ERP used when CRM gender is missing or unavailable. |
| cst_age | Customer age calculated from ERP birth date. |
| cntry | Customer country from ERP location data. |

---

## fact_sales

| Column | Description |
|---|---|
| sls_ord_num | Sales order number. |
| sls_prd_key | Product key used to link sales transactions to `dim_product.prd_key`. |
| sls_cust_id | Customer ID used to link sales transactions to `dim_customer.cst_id`. |
| sls_order_dt | Order date. |
| sls_ship_dt | Shipping date. |
| sls_due_dt | Due date. |
| sls_quantity | Quantity of units sold. |
| sls_price | Unit sale price. |
| sls_sales | Total sales amount for the transaction, calculated as quantity × price. |

---

## dim_product

| Column | Description |
|---|---|
| prd_key | Unique product key used to link product information to sales transactions. |
| cat_id | Product category identifier extracted from the CRM product key. |
| prd_nm | Product name. |
| prd_cost | Product cost. |
| prd_line | Standardized product line. |
| cat | Product category. |
| subcat | Product subcategory. |
| maintenance | Maintenance category or maintenance flag associated with the product. |
| prd_start_dt | Product start date. |
| prd_end_dt | Product end date. Null values indicate active products. |
| product_status | Product status, classified as Active, Inactive, or Unknown. |
