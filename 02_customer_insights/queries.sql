-- =============================================
-- Project 2: Customer Insights
-- Database: AdventureWorks
-- Author: [Your Name]
-- =============================================


-- Query 1: Top 20 Customers by Lifetime Revenue
-- Business Question: Who are our highest value customers?
-- Concepts: 3-table JOIN, GROUP BY, SUM, COUNT, TOP, ROUND
-- Note: LEFT JOIN to Person.Person handles business customers
--       who have no person record (PersonID is NULL)

SELECT TOP 20
    p.FirstName,
    p.LastName,
    COUNT(soh.SalesOrderID)     AS NumberOfOrders,
    ROUND(SUM(soh.TotalDue), 2) AS TotalRevenue
FROM Sales.SalesOrderHeader soh
LEFT JOIN Sales.Customer sc
    ON soh.CustomerID = sc.CustomerID
LEFT JOIN Person.Person p
    ON sc.PersonID = p.PersonID
GROUP BY p.FirstName, p.LastName
ORDER BY TotalRevenue DESC;


-- Query 2: Revenue and Orders per Sales Territory
-- Business Question: How is each sales territory performing?
-- Concepts: JOIN, GROUP BY, COUNT, SUM, ROUND

SELECT
    sst.Name                        AS TerritoryName,
    COUNT(soh.SalesOrderID)         AS NumberOfOrders,
    ROUND(SUM(soh.TotalDue), 2)     AS TotalRevenue
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesTerritory sst
    ON sst.TerritoryID = soh.TerritoryID
GROUP BY sst.Name
ORDER BY TotalRevenue DESC;


-- Query 3: Average Order Value per Customer (more than 3 orders)
-- Business Question: What is each customer's average order value?
-- Concepts: 3-table LEFT JOIN, AVG, HAVING, GROUP BY

SELECT
    p.FirstName,
    p.LastName,
    COUNT(soh.SalesOrderID)         AS NumberOfOrders,
    ROUND(AVG(soh.TotalDue), 2)     AS AvgOrderValue
FROM Sales.SalesOrderHeader soh
LEFT JOIN Sales.Customer sc
    ON soh.CustomerID = sc.CustomerID
LEFT JOIN Person.Person p
    ON sc.PersonID = p.PersonID
GROUP BY p.FirstName, p.LastName
HAVING COUNT(soh.SalesOrderID) > 3
ORDER BY AvgOrderValue DESC;


-- Query 4a: Loyalty Risk — Customers with Only One Order (HAVING approach)
-- Business Question: Which customers have placed only one order?
-- Concepts: LEFT JOIN, GROUP BY, HAVING COUNT = 1

SELECT
    p.FirstName,
    p.LastName,
    soh.OrderDate
FROM Sales.SalesOrderHeader soh
LEFT JOIN Sales.Customer sc
    ON soh.CustomerID = sc.CustomerID
LEFT JOIN Person.Person p
    ON sc.PersonID = p.PersonID
GROUP BY p.FirstName, p.LastName, soh.OrderDate
HAVING COUNT(soh.SalesOrderID) = 1
ORDER BY soh.OrderDate DESC;


-- Query 4b: Loyalty Risk — Subquery Approach (alternative solution)
-- Business Question: Same as above using a subquery instead of HAVING
-- Concepts: Subquery, WHERE IN

SELECT
    p.FirstName,
    p.LastName,
    soh.OrderDate
FROM Sales.SalesOrderHeader soh
LEFT JOIN Sales.Customer sc
    ON soh.CustomerID = sc.CustomerID
LEFT JOIN Person.Person p
    ON sc.PersonID = p.PersonID
WHERE soh.CustomerID IN (
    SELECT CustomerID
    FROM Sales.SalesOrderHeader
    GROUP BY CustomerID
    HAVING COUNT(SalesOrderID) = 1
)
ORDER BY soh.OrderDate DESC;


-- Query 5: Customer Tier Classification
-- Business Question: Classify all customers into Platinum, Gold, Silver tiers
-- Concepts: CTE, CASE WHEN, GROUP BY, SUM

WITH CustomerRevenue AS (
    SELECT
        sc.CustomerID,
        p.FirstName,
        p.LastName,
        ROUND(SUM(soh.TotalDue), 2) AS TotalRevenue
    FROM Sales.SalesOrderHeader soh
    LEFT JOIN Sales.Customer sc
        ON soh.CustomerID = sc.CustomerID
    LEFT JOIN Person.Person p
        ON sc.PersonID = p.PersonID
    GROUP BY sc.CustomerID, p.FirstName, p.LastName
)
SELECT
    FirstName,
    LastName,
    TotalRevenue,
    CASE
        WHEN TotalRevenue > 50000   THEN 'Platinum'
        WHEN TotalRevenue BETWEEN 10000 AND 50000 THEN 'Gold'
        ELSE                             'Silver'
    END AS CustomerTier
FROM CustomerRevenue
ORDER BY TotalRevenue DESC;


-- Query 6: Rank Customers by Revenue Within Each Territory
-- Business Question: How do customers rank against each other in their territory?
-- Concepts: CTE, DENSE_RANK, PARTITION BY

WITH CustomerTerritoryRevenue AS (
    SELECT
        p.FirstName,
        p.LastName,
        st.Name                         AS TerritoryName,
        ROUND(SUM(soh.TotalDue), 2)     AS TotalRevenue
    FROM Sales.SalesOrderHeader soh
    LEFT JOIN Sales.Customer sc
        ON soh.CustomerID = sc.CustomerID
    LEFT JOIN Person.Person p
        ON sc.PersonID = p.PersonID
    LEFT JOIN Sales.SalesTerritory st
        ON soh.TerritoryID = st.TerritoryID
    GROUP BY p.FirstName, p.LastName, st.Name
)
SELECT
    FirstName,
    LastName,
    TerritoryName,
    TotalRevenue,
    DENSE_RANK() OVER (
        PARTITION BY TerritoryName
        ORDER BY TotalRevenue DESC
    ) AS TerritoryRank
FROM CustomerTerritoryRevenue
ORDER BY TerritoryName, TerritoryRank;


-- Query 7: Top 3 Customers per Territory
-- Business Question: Who are the top 3 customers in each territory?
-- Concepts: Chained CTEs, DENSE_RANK, PARTITION BY, WHERE rank filter

WITH CustomerTerritoryRevenue AS (
    SELECT
        p.FirstName,
        p.LastName,
        st.Name                         AS TerritoryName,
        ROUND(SUM(soh.TotalDue), 2)     AS TotalRevenue
    FROM Sales.SalesOrderHeader soh
    LEFT JOIN Sales.Customer sc
        ON soh.CustomerID = sc.CustomerID
    LEFT JOIN Person.Person p
        ON sc.PersonID = p.PersonID
    LEFT JOIN Sales.SalesTerritory st
        ON soh.TerritoryID = st.TerritoryID
    GROUP BY p.FirstName, p.LastName, st.Name
),
RankedCustomers AS (
    SELECT
        FirstName,
        LastName,
        TerritoryName,
        TotalRevenue,
        DENSE_RANK() OVER (
            PARTITION BY TerritoryName
            ORDER BY TotalRevenue DESC
        ) AS TerritoryRank
    FROM CustomerTerritoryRevenue
)
SELECT *
FROM RankedCustomers
WHERE TerritoryRank <= 3
ORDER BY TerritoryName, TerritoryRank;
