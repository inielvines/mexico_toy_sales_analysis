-- Checking data types
DESCRIBE products;
DESCRIBE stores;
DESCRIBE calendar;
DESCRIBE inventory;
DESCRIBE sales;


-- Check row counts
SELECT COUNT(*) FROM products;   -- 35
SELECT COUNT(*) FROM stores;     -- 50
SELECT COUNT(*) FROM calendar;   -- 638
SELECT COUNT(*) FROM inventory;  -- 1593
SELECT COUNT(*) FROM sales;      -- 829,262

-- Inspect samples
SELECT * FROM products LIMIT 10;
SELECT * FROM stores LIMIT 10;
SELECT * FROM calendar LIMIT 10;
SELECT * FROM inventory LIMIT 10;
SELECT * FROM sales LIMIT 10;

SELECT * FROM sales LIMIT 10 OFFSET 200000;

-- Check for duplicates
SELECT Product_ID, COUNT(*) AS duplicates
FROM products
GROUP BY Product_ID
HAVING COUNT(*) > 1;

SELECT Store_ID, COUNT(*) AS duplicates
FROM stores
GROUP BY Store_ID
HAVING COUNT(*) > 1;

SELECT
    Store_ID,
    Product_ID,
    COUNT(*) AS duplicates
FROM inventory
GROUP BY Store_ID, Product_ID
HAVING COUNT(*) > 1;

-- Checking NULL values
SELECT *
FROM products
WHERE Product_ID IS NULL 
	OR Product_Name IS NULL 
    OR Product_Category IS NULL
    OR Product_Cost IS NULL
    OR Product_Price is NULL;

SELECT *
FROM stores
WHERE Store_ID IS NULL
	OR Store_Name IS NULL
    OR Store_City IS NULL
    OR Store_Location IS NULL
    OR Store_Open_Date IS NULL;
    
SELECT *
FROM calendar
WHERE `Date` IS NULL;

SELECT *
FROM inventory
WHERE Store_ID IS NULL
	OR Product_ID IS NULL
    OR Stock_On_Hand IS NULL;

SELECT *
FROM sales
WHERE Sale_ID IS NULL
	OR `Date` IS NULL
    OR Store_ID IS NULL
    OR Product_ID IS NULL
    OR Units IS NULL;



























