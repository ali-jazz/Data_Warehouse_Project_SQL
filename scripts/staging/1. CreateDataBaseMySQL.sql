/*
=======================================================================
Database Initialization Script
=======================================================================
Description:
    This script initializes the 'datawarehouse' database.

Behavior:
    - Creates the database if it does not already exist
    - Applies UTF-8 encoding for full character support
    - Safe to run multiple times

Best Practices:
    - Enforces strict SQL mode for data quality
=======================================================================
*/

-- Enable strict mode (data quality enforcement)
SET sql_mode = 'STRICT_TRANS_TABLES';

-- Create database
CREATE DATABASE IF NOT EXISTS datawarehouse
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

-- Use database
USE datawarehouse;
