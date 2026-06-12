-- =============================================
-- Project 1: Sales Analysis
-- Database: AdventureWorks
-- Author: [Your Name]
-- =============================================


-- Query 1: Top 10 Products by Revenue
-- Business Question: Which products generated the most revenue?
-- Concepts: JOIN, GROUP BY, SUM, TOP, ROUND

SELECT TOP 10
    p.ProductID,
    p.Name                        AS ProductName,
    ROUND(SUM(s.LineTotal), 2)    AS TotalRevenue
FROM Production.Product p
JOIN Sales.SalesOrderDetail s
    ON p.ProductID = s.ProductID
GROUP BY p.ProductID, p.Name
ORDER BY TotalRevenue DESC;


-- Query 2: Revenue by Product Category (over $1M only)
-- Business Question: Which product categories drive the most revenue?
-- Concepts: JOIN across 4 tables, GROUP BY, SUM, HAVING

SELECT
    pc.ProductCategoryID,
    pc.Name                     AS CategoryName,
    ROUND(SUM(s.LineTotal), 2)  AS TotalRevenue
FROM Sales.SalesOrderDetail s
JOIN Production.Product p
    ON s.ProductID = p.ProductID
JOIN Production.ProductSubcategory pps
    ON p.ProductSubcategoryID = pps.ProductSubcategoryID
JOIN Production.ProductCategory pc
    ON pps.ProductCategoryID = pc.ProductCategoryID
GROUP BY pc.ProductCategoryID, pc.Name
HAVING SUM(s.LineTotal) > 1000000
ORDER BY TotalRevenue DESC;


-- Query 3: Order Size Segmentation
-- Business Question: How many orders fall into Small, Medium, and Large segments?
-- Concepts: CASE WHEN, GROUP BY, COUNT, SUM

SELECT
    CASE
        WHEN TotalDue < 1000          THEN 'Small'
        WHEN TotalDue BETWEEN 1000
             AND 10000                THEN 'Medium'
        WHEN TotalDue > 10000         THEN 'Large'
    END                               AS OrderSegment,
    COUNT(SalesOrderID)               AS NumberOfOrders,
    ROUND(SUM(TotalDue), 2)           AS TotalRevenue
FROM Sales.SalesOrderHeader
GROUP BY
    CASE
        WHEN TotalDue < 1000          THEN 'Small'
        WHEN TotalDue BETWEEN 1000
             AND 10000                THEN 'Medium'
        WHEN TotalDue > 10000         THEN 'Large'
    END
ORDER BY TotalRevenue DESC;


-- Query 4: Monthly Sales Trend
-- Business Question: How has revenue trended month by month?
-- Concepts: YEAR(), MONTH(), GROUP BY, COUNT, SUM

SELECT
    YEAR(OrderDate)            AS OrderYear,
    MONTH(OrderDate)           AS OrderMonth,
    COUNT(SalesOrderID)        AS NumberOfOrders,
    ROUND(SUM(TotalDue), 2)    AS TotalRevenue
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY OrderYear, OrderMonth;
