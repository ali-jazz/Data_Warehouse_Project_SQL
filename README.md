# Data Warehouse & Analytics Project

## Overview
This project demonstrates the end-to-end design and implementation of a modern Data Warehouse, combined with business-oriented analytics and interactive dashboards.

The objective is to transform raw CRM and ERP data into structured, reliable, and actionable insights to support data-driven decision-making.

This project covers:

- **Data Architecture**: Implementation of a Medallion Architecture (Staging → Intermediate → Data Marts)
- **ETL Pipelines**: Data extraction, cleaning, transformation, and integration
- **Data Modeling**: Star schema design with fact and dimension tables
- **Analytics & Visualization**: SQL analysis and interactive dashboards using Power BI

---

## Data Architecture

The data pipeline follows a layered approach:

### Staging Layer
- Raw data ingestion from CSV files (CRM & ERP systems)

### Intermediate Layer
- Data cleaning, standardization, and transformation
- Deduplication using window functions
- Data reconciliation between systems

### Data Mart Layer
- Creation of analytical tables:
  - `dim_customer`
  - `dim_product`
  - `fact_sales`
- Optimized for reporting and BI tools

---

## ETL & Data Modeling

### Data Sources
- CRM System:
  - Customer information
  - Sales transactions
  - Product data
- ERP System:
  - Customer demographics (birthdate)
  - Customer location
  - Product categories

### Key Transformations
- Standardization of keys across systems
- Deduplication using `ROW_NUMBER()`
- Handling missing values (Unknown categories/products)
- Creation of derived attributes:
  - Customer age
  - Product status (Active / Inactive / Unknown)
  - Customer segmentation (age groups)

---

## Star Schema

The final model follows a **star schema**:

- **Fact Table**
  - `fact_sales`: transactional data

- **Dimension Tables**
  - `dim_customer`: customer attributes
  - `dim_product`: product and category hierarchy

This structure ensures:
- High performance for analytical queries
- Clear separation between facts and dimensions
- Compatibility with BI tools

---

## Business Questions & Insights

This project answers key business questions such as:

### Product Performance
- Which products generate the most revenue?
- Which product categories dominate sales?
- What are the top-selling products?

### Market Analysis
- Which countries generate the highest revenue?
- How is revenue distributed geographically?

### Customer Segmentation
- Which age groups contribute most to revenue?
- Are there differences in purchasing behavior by gender?
- How does marital status impact sales?

---

## Power BI Dashboard

An interactive dashboard was built using **Power BI** to visualize insights.

### Key Features
- KPI Cards:
  - Total Revenue
  - Total Quantity Sold
- Sales by Country (Top markets)
- Product Category & Subcategory Analysis
- Top 10 Best-Selling Products
- Customer Segmentation:
  - Age groups
  - Gender
  - Marital status
- Interactive **slicers**:
  - Country
  - Product category
  - Age group
  - Marital status

### Insights from Dashboard
- A small number of products drive a large portion of revenue
- The **Bikes category dominates total sales**
- Customers aged **40–60 represent the most valuable segment**
- Revenue is concentrated in a few key countries (US, Australia)

---

## Data Challenges

- Missing values in customer and product data
- Inconsistent product keys across systems
- Duplicate records
- Products present in sales but missing from product master data

### Solutions Implemented
- Data standardization and normalization
- Deduplication using window functions (`ROW_NUMBER()`)
- Creation of "Unknown Product" records to ensure referential integrity
- Validation of joins between fact and dimension tables

---

## Results

- Built a fully functional Data Warehouse from raw CSV files
- Implemented a clean and scalable star schema
- Ensured data consistency and integrity across systems
- Delivered an interactive dashboard for business insights

---

## Tech Stack

- **MySQL** (Data Warehouse & ETL)
- **SQL (Advanced)** (Transformations & modeling)
- **Power BI** (Data visualization & dashboarding)

---
##  Repository Structure
```
data-warehouse-project/
│
├── datasets/                           # Raw datasets used for the project (ERP and CRM data)
│
├── docs/                               # Project documentation and architecture details
│   ├── data_catalog.md                 # Catalog of datasets, including field descriptions and metadata
│   ├── data_models.drawio              # Draw.io file for data models (star schema)
│   ├── data_integration.drawio         # Draw.io file to display how the tables are related
│
├── powerbi/                            # PowerBI Dashboad screenshots
│  ├── dashboard.png                    
│  ├── filter.png                      
│
├── scripts/                            # SQL scripts for ETL and transformations
│   ├── staging/                        # Scripts for extracting and loading raw data
│   ├── intermediate/                   # Scripts for cleaning and transforming data
│   ├── analysis/                       # Scripts for creating analytical models
│
├── README.md                           # Project overview and instructions
├── LICENSE                             # License information for the repository
```
---
##  License

This project is licensed under the [MIT License](LICENSE). You are free to use, modify, and share this project with proper attribution.
