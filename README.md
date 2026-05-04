# Data Warehouse Project

##  Overview
This project demonstrates the design and implementation of a modern Data Warehouse using SQL Server. It showcases best practices in data modeling, ETL processes, and analytical reporting.

The goal is to transform raw data into structured, reliable, and actionable insights that support data-driven decision-making.

1. **Data Architecture**: Designing a Modern Data Warehouse Using Medallion Architecture **Staging**, **Intermediate**, and **Data Marts** layers.
2. **ETL Pipelines**: Extracting, transforming, and loading data from source systems into the warehouse.
3. **Data Modeling**: Developing fact and dimension tables optimized for analytical queries.
4. **Analytics & Reporting**: Creating SQL-based reports and dashboards for actionable insights.
   
---

## Tasks
- Import data from two source systems (ERP and CRM) provided as CSV files.
- Cleanse and resolve data quality issues prior to analysis.
- Combine both sources into a single, user-friendly data model designed for analytical queries.
- Focus on the latest dataset only; historization of data is not required.
- Provide clear documentation of the data model to support both business stakeholders and analytics teams.

---
## Key Insights
- Identified top-performing products contributing to 60% of total revenue
- Discovered customer segments with highest purchase frequency
- Detected seasonal sales trends impacting revenue patterns

---

##  Tech Stack
- SQL Server
- T-SQL
- SSMS (SQL Server Management Studio)

---

##  Data Architecture
- Staging Layer: Raw data ingestion. Data is ingested from CSV Files into SQL Server Database.
- Intermediate Layer: Cleaned and structured data, and normalization processes to prepare data for analysis.
- Data Marts: Business-oriented datasets for analysis

---
##  Data Challenges
- Missing values in customer and sales data
- Inconsistent product naming across ERP and CRM systems
- Duplicate records across sources
- Date format inconsistencies

### Solutions
- Applied data standardization and normalization techniques
- Used deduplication logic with window functions
- Implemented data validation checks before loading

---
##  Results
- Built a fully functional Data Warehouse from raw CSV data
- Improved data consistency and usability for analytics
- Enabled faster querying through structured data modeling

---
##  Repository Structure

---
##  License

This project is licensed under the [MIT License](LICENSE). You are free to use, modify, and share this project with proper attribution.
