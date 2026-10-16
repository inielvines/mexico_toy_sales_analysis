-- ============================================================
-- Maven Toys: Database Setup and Data Import
-- ============================================================

CREATE DATABASE IF NOT EXISTS maven_toys;
USE maven_toys;


-- ============================================================
-- 1. CREATE TABLES
-- ============================================================

-- Raw products table: preserves original currency strings.
CREATE TABLE IF NOT EXISTS products_raw (
    Product_ID INT PRIMARY KEY,
    Product_Name VARCHAR(100),
    Product_Category VARCHAR(50),
    Product_Cost VARCHAR(20),
    Product_Price VARCHAR(20)
);

-- Clean products table: numeric cost and price.
CREATE TABLE IF NOT EXISTS products (
    Product_ID INT PRIMARY KEY,
    Product_Name VARCHAR(100),
    Product_Category VARCHAR(50),
    Product_Cost DECIMAL(10,2),
    Product_Price DECIMAL(10,2)
);

CREATE TABLE IF NOT EXISTS stores (
    Store_ID INT PRIMARY KEY,
    Store_Name VARCHAR(100),
    Store_City VARCHAR(50),
    Store_Location VARCHAR(50),
    Store_Open_Date DATE
);

CREATE TABLE IF NOT EXISTS calendar (
    `Date` DATE PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS inventory (
    Store_ID INT,
    Product_ID INT,
    Stock_On_Hand INT,

    PRIMARY KEY (Store_ID, Product_ID),

    FOREIGN KEY (Store_ID)
        REFERENCES stores(Store_ID),

    FOREIGN KEY (Product_ID)
        REFERENCES products(Product_ID)
);

CREATE TABLE IF NOT EXISTS sales (
    Sale_ID INT PRIMARY KEY,
    `Date` DATE,
    Store_ID INT,
    Product_ID INT,
    Units INT,

    FOREIGN KEY (`Date`)
        REFERENCES calendar(`Date`),

    FOREIGN KEY (Store_ID)
        REFERENCES stores(Store_ID),

    FOREIGN KEY (Product_ID)
        REFERENCES products(Product_ID)
);


-- ============================================================
-- 2. IMPORT RAW PRODUCTS
-- ============================================================

LOAD DATA LOCAL INFILE
'C:/Users/LENOVO/Downloads/Analyst Project1/Maven Toys Data/products.csv'
INTO TABLE products_raw
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(
    Product_ID,
    Product_Name,
    Product_Category,
    Product_Cost,
    Product_Price
);


-- Clean currency values and populate products.
INSERT INTO products (
    Product_ID,
    Product_Name,
    Product_Category,
    Product_Cost,
    Product_Price
)
SELECT
    Product_ID,
    Product_Name,
    Product_Category,
    REPLACE(TRIM(Product_Cost), '$', ''),
    REPLACE(TRIM(Product_Price), '$', '')
FROM products_raw;


-- ============================================================
-- 3. IMPORT STORES
-- ============================================================

LOAD DATA LOCAL INFILE
'C:/Users/LENOVO/Downloads/Analyst Project1/Maven Toys Data/stores.csv'
INTO TABLE stores
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(
    Store_ID,
    Store_Name,
    Store_City,
    Store_Location,
    Store_Open_Date
);


-- ============================================================
-- 4. IMPORT CALENDAR
-- Convert M/D/YYYY into a MySQL DATE.
-- ============================================================

LOAD DATA LOCAL INFILE
'C:/Users/LENOVO/Downloads/Analyst Project1/Maven Toys Data/calendar.csv'
INTO TABLE calendar
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@raw_date)
SET `Date` = STR_TO_DATE(TRIM(@raw_date), '%m/%d/%Y');


-- ============================================================
-- 5. IMPORT INVENTORY
-- ============================================================

LOAD DATA LOCAL INFILE
'C:/Users/LENOVO/Downloads/Analyst Project1/Maven Toys Data/inventory.csv'
INTO TABLE inventory
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(
    Store_ID,
    Product_ID,
    Stock_On_Hand
);


-- ============================================================
-- 6. IMPORT SALES
-- ============================================================

LOAD DATA LOCAL INFILE
'C:/Users/LENOVO/Downloads/Analyst Project1/Maven Toys Data/sales.csv'
INTO TABLE sales
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(
    Sale_ID,
    `Date`,
    Store_ID,
    Product_ID,
    Units
);