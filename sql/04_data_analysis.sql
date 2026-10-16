-- ========================================
-- 			  DATA ANALYSIS
-- ========================================


-- ========================================
-- 			 SALES PERFORMANCE
-- ========================================

-- How is revenue performing over time?
SELECT 
	DATE_FORMAT(`Date`, '%Y-%m') AS MONTH, 
	ROUND(SUM(p.Product_Price * s.Units), 2) AS total_sales
FROM sales AS s
JOIN products AS p
	ON s.Product_ID = p.Product_ID
GROUP BY DATE_FORMAT(`Date`, '%Y-%m');


-- ========================================
-- 			 PRODUCT PERFORMANCE
-- ========================================

-- Which products generate the most revenue?
SELECT 
	p.Product_Name, 
	SUM(p.Product_Price * s.Units) AS total_sales
FROM sales AS s
JOIN products AS p
	ON s.Product_ID = p.Product_ID
GROUP BY p.Product_Name
ORDER BY total_sales DESC;

-- Which product categories are most profitable?
SELECT 
	p.Product_Category, 
	SUM((p.Product_Price - p.Product_Cost) * s.Units) AS profit
FROM sales AS s
JOIN products AS p
	ON s.Product_ID = p.Product_ID
GROUP BY p.Product_Category
ORDER BY profit DESC;

-- Are there products that appear to be selling poorly?
WITH product_sold AS (
	SELECT 
		p.Product_Name, 
        SUM(Units) AS units_sold
	FROM products AS p
	JOIN sales AS s
		ON p.Product_ID = s.Product_ID
	GROUP BY p.Product_Name
) 
SELECT Product_Name, units_sold
FROM product_sold
WHERE units_sold < (
	SELECT AVG(units_sold)
    FROM product_sold
)
ORDER BY units_sold;


-- ========================================
-- 			 STORE PERFORMANCE
-- ========================================

-- Which stores are most profitable?
SELECT 
	store.Store_Name, 
    SUM((p.Product_Price - p.Product_Cost) * s.Units) AS profit
FROM sales AS s
JOIN products AS p
	ON s.Product_ID = p.Product_ID
JOIN stores AS store
	ON s.Store_ID = store.Store_ID
GROUP BY store.Store_Name
ORDER BY profit DESC;


-- ========================================
-- 		LOCATION PERFORMANCE ANALYSIS
-- ========================================

-- Which locations underperform?
WITH location_revenue AS (
	SELECT store.Store_Location, SUM(p.Product_Price * s.Units) AS revenue
    FROM stores AS store
	JOIN sales AS s
		ON store.Store_ID = s.Store_ID
	JOIN products AS p
		ON s.Product_ID = p.Product_ID
	GROUP BY store.Store_Location
),
average_revenue AS (
	SELECT AVG(revenue) AS average
    FROM location_revenue
)
SELECT Store_Location, revenue
FROM location_revenue
WHERE revenue < (
	SELECT average
    FROM average_revenue
);
-- Compare location performance based on transaction volume, total revenue, and revenue per transaction
SELECT 
	store.Store_Location, 
    COUNT(*) AS sales_record,
    ROUND(SUM(p.Product_Price * s.Units), 2) AS revenue,
    ROUND((SUM(p.Product_Price * s.Units) / COUNT(*)), 2) AS revenue_per_transaction
FROM stores AS store
JOIN sales AS s
	ON store.Store_ID = s.Store_ID
JOIN products AS p
	ON s.Product_ID = p.Product_ID
GROUP BY store.Store_Location
ORDER BY revenue DESC;



-- ========================================
-- 			 INVENTORY ANALYSIS
-- ========================================


-- How much inventory is sitting in stores?
SELECT SUM(Stock_On_Hand) AS stock
FROM inventory;

-- Which products have high revenue but low inventory
WITH product_sales AS (
	SELECT 
		p.Product_ID,
		p.Product_Name, 
        SUM(p.Product_Price * s.Units) AS revenue
    FROM products AS p
    JOIN sales AS s
		ON p.Product_ID = s.Product_ID
	GROUP BY p.Product_ID, p.Product_Name
),
product_inventory AS (
	SELECT 
		p.Product_ID,
		p.Product_Name, 
        SUM(inv.Stock_On_Hand) AS stock
    FROM products AS p
    JOIN inventory AS inv
		ON p.Product_ID = inv.Product_ID
	GROUP BY p.Product_ID, p.Product_Name
)
SELECT
	ps.Product_Name,
    ps.revenue,
    pi.stock
FROM product_sales AS ps
JOIN product_inventory AS pi
	ON ps.Product_ID = pi.Product_ID
WHERE ps.revenue > (
	SELECT AVG(revenue)
    FROM product_sales
) AND pi.stock < (
	SELECT AVG(stock)
    FROM product_inventory
);
























    


