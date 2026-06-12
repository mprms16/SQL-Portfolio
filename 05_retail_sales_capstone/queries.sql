-- =============================================
-- Project 5: Retail Sales Analysis (Capstone)
-- Database: RetailDB (Superstore Sales Dataset)
-- Author: [Your Name]
-- =============================================

-- DATA QUALITY NOTES:
-- 1. Found and removed 1 duplicate order line using ROW_NUMBER() CTE pattern (Query 9)
--    Table reduced from 9,994 to 9,993 rows after deletion
-- 2. Product names cleaned using REPLACE to remove commas for CSV export (Query 5)
-- 3. City names were already standardized in this dataset (e.g. 'Saint Louis' not 'St. Louis')


-- Query 1: Earliest and Latest Order Dates
-- Business Question: What is the full date range of orders in the system?
-- Concepts: MIN, MAX

SELECT
    MIN(Order_Date)     AS EarliestOrder,
    MAX(Order_Date)     AS LatestOrder
FROM Orders;


-- Query 2: Product Name and Category Combined
-- Business Question: Create a combined product label for marketing use
-- Concepts: CONCAT, DISTINCT

SELECT DISTINCT
    Product_ID,
    CONCAT(Category, ' — ', Product_Name)  AS ProductLabel
FROM Orders;


-- Query 3: Orders, Sales and Profit per Region
-- Business Question: How does each region perform in orders, sales, and profit?
-- Concepts: GROUP BY, COUNT, SUM, ROUND

SELECT
    Region,
    COUNT(*)                        AS TotalNumberOfOrders,
    ROUND(SUM(Sales), 2)            AS TotalSales,
    ROUND(SUM(Profit), 2)           AS TotalProfit
FROM Orders
GROUP BY Region
ORDER BY TotalSales DESC;


-- Query 4: Average Sales per Category
-- Business Question: What is the average order value across product categories?
-- Concepts: GROUP BY, AVG, ROUND

SELECT
    Category,
    ROUND(AVG(Sales), 2)    AS AvgSales
FROM Orders
GROUP BY Category
ORDER BY AvgSales DESC;


-- Query 5: Clean Product Names for Reporting
-- Business Question: Remove commas from product names for CSV export compatibility
-- Concepts: REPLACE, DISTINCT
-- Note: Commas in product names cause formatting issues when exported to CSV
--       since commas act as delimiters. REPLACE standardizes names for
--       system integration — a common real-world ETL requirement

SELECT DISTINCT
    Product_Name                            AS OriginalName,
    REPLACE(Product_Name, ',', ' -')        AS CleanedName
FROM Orders
ORDER BY OriginalName;


-- Query 6: Convert Order Dates to Different Formats
-- Business Question: Display order dates in multiple formats for different systems
-- Concepts: CONVERT, DATENAME, YEAR, CONCAT, DISTINCT

SELECT DISTINCT
    Order_Date                                          AS OriginalDate,
    CONVERT(VARCHAR, Order_Date, 101)                   AS MMDDYYYY,
    CONCAT(DATENAME(month, Order_Date), ' ',
           YEAR(Order_Date))                            AS MonthYear
FROM Orders
ORDER BY Order_Date;


-- Query 7: Ceiling of Average Profit per Category
-- Business Question: What is the average profit per category rounded up to nearest dollar?
-- Concepts: CEILING, AVG, GROUP BY
-- Note: CEILING always rounds UP regardless of decimal value
--       unlike ROUND which rounds to nearest

SELECT
    Category,
    CEILING(AVG(Profit))    AS AvgProfit
FROM Orders
GROUP BY Category
ORDER BY AvgProfit DESC;


-- Query 8: Discount Impact on Profit
-- Business Question: How do different discount levels affect profitability?
-- Concepts: CASE WHEN, BETWEEN, GROUP BY, COUNT, AVG, SUM
-- Note: Discount tiers defined based on exploratory data analysis
--       and standard retail discount practices

SELECT
    CASE
        WHEN Discount = 0                       THEN 'No Discount'
        WHEN Discount BETWEEN 0.01 AND 0.20     THEN 'Low'
        WHEN Discount BETWEEN 0.21 AND 0.40     THEN 'Medium'
        WHEN Discount > 0.40                    THEN 'High'
    END                                         AS DiscountTiers,
    COUNT(Order_ID)                             AS TotalOrders,
    ROUND(AVG(Profit), 2)                       AS AvgProfit,
    ROUND(SUM(Sales), 2)                        AS TotalSales
FROM Orders
GROUP BY
    CASE
        WHEN Discount = 0                       THEN 'No Discount'
        WHEN Discount BETWEEN 0.01 AND 0.20     THEN 'Low'
        WHEN Discount BETWEEN 0.21 AND 0.40     THEN 'Medium'
        WHEN Discount > 0.40                    THEN 'High'
    END
ORDER BY DiscountTiers DESC;


-- Query 9: Find and Remove Duplicate Orders
-- Business Question: Identify and delete duplicate order lines
-- Concepts: ROW_NUMBER, CTE, DELETE
-- IMPORTANT: Always preview before deleting

-- Step 1: Preview duplicates first
WITH DuplicateOrders AS (
    SELECT
        Row_ID,
        Order_ID,
        Product_ID,
        Sales,
        ROW_NUMBER() OVER (
            PARTITION BY Order_ID, Product_ID, Sales
            ORDER BY Row_ID
        ) AS RowNum
    FROM Orders
)
SELECT * FROM DuplicateOrders
WHERE RowNum > 1;
-- Result: 1 duplicate found

-- Step 2: Delete duplicates (keeps RowNum = 1, deletes RowNum > 1)
WITH DuplicateOrders AS (
    SELECT
        Row_ID,
        ROW_NUMBER() OVER (
            PARTITION BY Order_ID, Product_ID, Sales
            ORDER BY Row_ID
        ) AS RowNum
    FROM Orders
)
DELETE FROM DuplicateOrders
WHERE RowNum > 1;
-- Result: Table reduced from 9,994 to 9,993 rows

-- Step 3: Verify deletion
SELECT COUNT(*) AS TotalRows FROM Orders;
-- Expected: 9,993


-- Query 10: Revenue and Profit by Region AND Category
-- Business Question: How does each region-category combination perform?
-- Concepts: GROUP BY multiple columns, SUM, ROUND

SELECT
    Region,
    Category,
    ROUND(SUM(Sales), 2)    AS TotalSales,
    ROUND(SUM(Profit), 2)   AS TotalProfit
FROM Orders
GROUP BY Region, Category
ORDER BY Region, TotalSales DESC;


-- Query 11: Classify Orders into Profit Tiers
-- Business Question: How do orders break down into profit tiers?
-- Concepts: CASE WHEN, CTE, COUNT, SUM, AVG, GROUP BY
-- Note: CTE needed because CASE WHEN creates the tier label first,
--       then the main query groups and aggregates by that label

WITH ProfitTiers AS (
    SELECT
        Order_ID,
        Profit,
        CASE
            WHEN Profit > 100   THEN 'High Profit'
            WHEN Profit > 0     THEN 'Low Profit'
            WHEN Profit = 0     THEN 'Break Even'
            ELSE                     'Loss'
        END AS ProfitTier
    FROM Orders
)
SELECT
    ProfitTier,
    COUNT(Order_ID)         AS TotalOrders,
    ROUND(SUM(Profit), 2)   AS TotalProfit,
    ROUND(AVG(Profit), 2)   AS AvgProfit
FROM ProfitTiers
GROUP BY ProfitTier
ORDER BY TotalProfit DESC;


-- Query 12: Customers with More Than 5 Orders
-- Business Question: Who are the most frequent shoppers?
-- Concepts: GROUP BY, COUNT, SUM, AVG, HAVING

SELECT
    Customer_Name,
    COUNT(Order_ID)             AS NumberOfOrders,
    ROUND(SUM(Sales), 2)        AS TotalSales,
    ROUND(AVG(Sales), 2)        AS AvgOrderValue
FROM Orders
GROUP BY Customer_Name
HAVING COUNT(Order_ID) > 5
ORDER BY NumberOfOrders DESC;


-- Query 13: Running Total of Sales by Order Date
-- Business Question: How do sales accumulate over time?
-- Concepts: SUM() OVER, window function, CTE
-- Note: CTE needed to first combine multiple orders per day into
--       one daily total — otherwise running total calculates incorrectly
--       because the same date appears multiple times in raw Orders table

WITH DailySales AS (
    SELECT
        Order_Date,
        ROUND(SUM(Sales), 2)    AS DailySales
    FROM Orders
    GROUP BY Order_Date
)
SELECT
    Order_Date,
    DailySales,
    ROUND(SUM(DailySales) OVER (
        ORDER BY Order_Date
    ), 2)                       AS RunningTotal
FROM DailySales
ORDER BY Order_Date;


-- Query 14: Rank Products by Sales Within Each Category
-- Business Question: Which products perform best within their category?
-- Concepts: CTE, DENSE_RANK, PARTITION BY, SUM, GROUP BY

WITH ProductSales AS (
    SELECT
        Product_Name,
        Category,
        ROUND(SUM(Sales), 2)    AS TotalSales
    FROM Orders
    GROUP BY Product_Name, Category
)
SELECT
    Product_Name,
    Category,
    TotalSales,
    DENSE_RANK() OVER (
        PARTITION BY Category
        ORDER BY TotalSales DESC
    ) AS CategoryRank
FROM ProductSales
ORDER BY Category, CategoryRank;


-- Query 15: Customers with Declining Order Values
-- Business Question: Which customers show declining engagement?
-- Concepts: LAG, chained CTEs, PARTITION BY, IS NOT NULL
-- Note: LAG looks back at the previous row's value within each customer's
--       order history. IS NOT NULL filters out first-ever orders
--       which have no previous order to compare against

WITH CustomerOrders AS (
    SELECT
        Customer_Name,
        Order_Date,
        ROUND(SUM(Sales), 2)    AS OrderTotal
    FROM Orders
    GROUP BY Customer_Name, Order_Date
),
CustomerOrderLag AS (
    SELECT
        Customer_Name,
        Order_Date,
        OrderTotal,
        LAG(OrderTotal, 1) OVER (
            PARTITION BY Customer_Name
            ORDER BY Order_Date
        )                       AS PreviousOrder
    FROM CustomerOrders
)
SELECT
    Customer_Name,
    PreviousOrder,
    OrderTotal                  AS LastOrder,
    ROUND(OrderTotal
          - PreviousOrder, 2)   AS Difference
FROM CustomerOrderLag
WHERE OrderTotal < PreviousOrder
    AND PreviousOrder IS NOT NULL
ORDER BY Difference;


-- Query 16: Products Selling Above Their Category Average Profit
-- Business Question: Which products outperform their category average?
-- Concepts: Chained CTEs, AVG, SUM, JOIN CTEs, WHERE filter

WITH CategoryAvg AS (
    SELECT
        Category,
        ROUND(AVG(Profit), 2)   AS AvgCategoryProfit
    FROM Orders
    GROUP BY Category
),
ProductProfit AS (
    SELECT
        Product_Name,
        Category,
        ROUND(SUM(Profit), 2)   AS TotalProfit
    FROM Orders
    GROUP BY Product_Name, Category
)
SELECT
    pp.Product_Name,
    pp.Category,
    pp.TotalProfit,
    ca.AvgCategoryProfit,
    ROUND(pp.TotalProfit
          - ca.AvgCategoryProfit, 2)    AS AboveAvgBy
FROM ProductProfit pp
JOIN CategoryAvg ca
    ON pp.Category = ca.Category
WHERE pp.TotalProfit > ca.AvgCategoryProfit
ORDER BY AboveAvgBy DESC;


-- Query 17: Top 3 Products per Region by Total Sales
-- Business Question: Which products are the top 3 sellers in each region?
-- Concepts: Chained CTEs, ROW_NUMBER, PARTITION BY, WHERE rank filter

WITH ProductRegionSales AS (
    SELECT
        Product_Name,
        Region,
        ROUND(SUM(Sales), 2)    AS TotalSales
    FROM Orders
    GROUP BY Product_Name, Region
),
RankedProducts AS (
    SELECT
        Product_Name,
        Region,
        TotalSales,
        ROW_NUMBER() OVER (
            PARTITION BY Region
            ORDER BY TotalSales DESC
        ) AS RegionalRank
    FROM ProductRegionSales
)
SELECT *
FROM RankedProducts
WHERE RegionalRank <= 3
ORDER BY Region, RegionalRank;


-- Query 18: Monthly Sales Trend Year Over Year
-- Business Question: How have monthly sales trended across all years?
-- Concepts: YEAR, MONTH, GROUP BY, COUNT, SUM, AVG, ROUND
-- Note: No CTE needed — COUNT, SUM, and AVG all read from the same
--       raw table simultaneously in one step

SELECT
    YEAR(Order_Date)            AS OrderYear,
    MONTH(Order_Date)           AS OrderMonth,
    COUNT(Order_ID)             AS NumberOfOrders,
    ROUND(SUM(Sales), 2)        AS TotalSales,
    ROUND(AVG(Sales), 2)        AS AvgOrderValue
FROM Orders
GROUP BY YEAR(Order_Date), MONTH(Order_Date)
ORDER BY OrderYear, OrderMonth;


-- Query 19: Executive Sales Dashboard View
-- Business Question: Create a reusable view for executive BI reporting
-- Concepts: CREATE VIEW, GROUP BY, COUNT, SUM, profit margin calculation
-- Usage: SELECT * FROM vw_ExecutiveDashboard WHERE Region = 'West'

CREATE VIEW vw_ExecutiveDashboard AS
SELECT
    Region,
    Category,
    COUNT(Order_ID)                             AS TotalOrders,
    ROUND(SUM(Sales), 2)                        AS TotalSales,
    ROUND(SUM(Profit), 2)                       AS TotalProfit,
    ROUND(SUM(Profit) / SUM(Sales) * 100, 2)   AS ProfitMargin
FROM Orders
GROUP BY Region, Category;

-- Query the view
SELECT * FROM vw_ExecutiveDashboard
ORDER BY TotalSales DESC;


-- Query 20: Stored Procedure for Regional Sales Report
-- Business Question: Create a reusable report that analysts can run for any region
-- Concepts: CREATE PROCEDURE, parameters, BEGIN...END, EXEC
-- Usage: EXEC usp_RegionalSalesReport @Region = 'West'

CREATE PROCEDURE usp_RegionalSalesReport
    @Region     VARCHAR(50)
AS
BEGIN
    SELECT
        Region,
        COUNT(Order_ID)             AS TotalOrders,
        ROUND(SUM(Sales), 2)        AS TotalSales,
        ROUND(SUM(Profit), 2)       AS TotalProfit,
        ROUND(AVG(Sales), 2)        AS AvgOrderValue
    FROM Orders
    WHERE Region = @Region
    GROUP BY Region;
END;

-- Execute for all 4 regions
EXEC usp_RegionalSalesReport @Region = 'East';
EXEC usp_RegionalSalesReport @Region = 'West';
EXEC usp_RegionalSalesReport @Region = 'Central';
EXEC usp_RegionalSalesReport @Region = 'South';
