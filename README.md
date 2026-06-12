# SQL Portfolio
**Author:** Maria Ramos  
**Tools:** SQL Server Management Studio 22, T-SQL  
**Databases:** AdventureWorks, HealthcareDB, HRAnalyticsDB, RetailDB  

## Overview
This portfolio demonstrates SQL skills across 5 projects, 4 databases, and 3 industries. 
It covers everything from basic SELECT queries to advanced window functions, CTEs, 
stored procedures, and views — built to showcase junior to mid-level SQL development skills.

---

## Projects

### [Project 1 — Sales Analysis](./01_sales_analysis/)
**Database:** AdventureWorks | **Queries:** 4  
Product revenue analysis, category performance, order segmentation, and monthly trends.  
**Key concepts:** Multi-table JOINs, GROUP BY, HAVING, CASE WHEN, date functions

---

### [Project 2 — Customer Insights](./02_customer_insights/)
**Database:** AdventureWorks | **Queries:** 7  
Customer value ranking, territory performance, loyalty risk, and tier classification.  
**Key concepts:** CTEs, DENSE_RANK, PARTITION BY, subqueries, LEFT JOINs, window functions

---

### [Project 3 — Healthcare Analysis](./03_healthcare_analysis/)
**Database:** HealthcareDB (Kaggle — 55,500 patients) | **Queries:** 7  
Patient demographics, billing analysis, clinical outcomes, and doctor performance.  
**Key concepts:** Data cleaning, DATEDIFF, conditional aggregation COUNT(CASE WHEN), CTEs

---

### [Project 4 — HR Analytics](./04_hr_analytics/)
**Database:** HRAnalyticsDB (IBM Kaggle — 1,470 employees) | **Queries:** 7  
Attrition analysis, salary distribution, overtime impact, and compensation benchmarking.  
**Key concepts:** Percentage calculations, DENSE_RANK, PARTITION BY, CTE row-level comparisons

---

### [Project 5 — Retail Sales Capstone](./05_retail_sales_capstone/)
**Database:** RetailDB (Superstore Kaggle — 9,993 orders) | **Queries:** 20  
Comprehensive retail analysis covering products, regions, customers, discounts, and trends.  
**Key concepts:** MIN/MAX, CONCAT, REPLACE, CONVERT, CEILING, DELETE duplicates, 
running totals SUM() OVER, LAG, CREATE VIEW, CREATE PROCEDURE

---

## Skills Demonstrated

| Category | Skills |
|---|---|
| **Querying** | SELECT, WHERE, ORDER BY, DISTINCT, TOP, BETWEEN |
| **Aggregations** | COUNT, SUM, AVG, MIN, MAX, ROUND, CEILING |
| **Joins** | INNER JOIN, LEFT JOIN (up to 4 tables) |
| **Grouping** | GROUP BY, HAVING |
| **Conditional** | CASE WHEN, ISNULL, COALESCE |
| **String functions** | CONCAT, REPLACE |
| **Date functions** | YEAR, MONTH, DATEDIFF, DATENAME, CONVERT, CAST |
| **Subqueries** | WHERE IN, correlated subqueries |
| **CTEs** | Single CTE, chained CTEs, CTE joined back to main table |
| **Window functions** | DENSE_RANK, ROW_NUMBER, LAG, SUM() OVER, PARTITION BY |
| **Data cleaning** | UPDATE, DELETE duplicates, UPPER/LOWER/SUBSTRING |
| **Database objects** | CREATE VIEW, CREATE PROCEDURE with parameters |

---

## Industries Covered
- **Retail/Sales** — AdventureWorks + Superstore dataset
- **Healthcare** — Patient billing and clinical outcomes
- **Human Resources** — Employee attrition and compensation

---

## How to Run
1. Install SQL Server Management Studio 22
2. Download the relevant database (AdventureWorks, or import CSV datasets from Kaggle)
3. Open the `queries.sql` file in SSMS
4. Execute queries individually or all at once
5. Each query includes comments explaining the business question and concepts used
