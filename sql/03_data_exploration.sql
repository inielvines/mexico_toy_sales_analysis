-- ========================================
-- 			  DATA EXPLORATION
-- ========================================

-- Date range/scope
SELECT MIN(`Date`) AS first_date, MAX(`Date`) AS last_date
FROM calendar;

-- Data distribution
SELECT
    MIN(Units) AS min_units,
    MAX(Units) AS max_units,
    AVG(Units) AS avg_units
FROM sales;

SELECT
    MIN(Product_Cost) AS min_cost,
    MAX(Product_Cost) AS max_cost,
    AVG(Product_Cost) AS avg_cost
FROM products;

SELECT
    MIN(Product_Price) AS min_price,
    MAX(Product_Price) AS max_price,
    AVG(Product_Price) AS avg_price
FROM products;


-- Categories
SELECT
    Product_Category,
    COUNT(*) AS product_count
FROM products
GROUP BY Product_Category
ORDER BY product_count DESC;


SELECT
    COUNT(DISTINCT Store_ID) AS stores,
    COUNT(DISTINCT Product_ID) AS products
FROM inventory;
