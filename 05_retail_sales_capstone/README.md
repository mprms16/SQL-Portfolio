# Project 5: Retail Sales Analysis (Capstone)
**Database:** RetailDB  
**Source:** Superstore Sales Dataset (Kaggle) — 9,993 orders (after cleaning)  
**Tools:** SQL Server Management Studio 22, T-SQL  

## Overview
This capstone project is the most comprehensive in the portfolio, covering 20 queries 
across all SQL skill levels. It analyzes retail sales data from a US superstore covering 
orders, products, customers, regions, and profitability from 2014 to 2017. 
It demonstrates the full range of T-SQL skills relevant to junior SQL developer roles.

## Data Cleaning Performed
- **Duplicate removal:** Found and removed 1 duplicate order line using ROW_NUMBER() 
  CTE pattern — table reduced from 9,994 to 9,993 rows (verified with COUNT after deletion)
- **Product name standardization:** Replaced commas in product names with dashes 
  using REPLACE — common requirement when preparing data for CSV exports where 
  commas act as delimiters
- **City names:** Already standardized in dataset (e.g. 'Saint Louis' not 'St. Louis') — 
  documented as assumption in analysis

## Business Questions Answered
1. What is the full date range of orders in the system?
2. How can product names and categories be combined for reporting?
3. How does each region perform in orders, sales, and profit?
4. What is the average sales per product category?
5. How can product names be standardized for CSV export compatibility?
6. How can order dates be displayed in multiple formats for different systems?
7. What is the ceiling of average profit per category?
8. How do different discount levels affect profitability?
9. How are duplicate orders identified and removed?
10. What is revenue and profit by region AND category combined?
11. How do orders break down into High Profit, Low Profit, Break Even, and Loss tiers?
12. Who are the most frequent customers (more than 5 orders)?
13. How do sales accumulate over time as a running total?
14. Which products rank highest by sales within their category?
15. Which customers show declining order values between purchases?
16. Which products outperform their category average profit?
17. Who are the top 3 products in each region by total sales?
18. How have monthly sales trended year over year?
19. Executive dashboard view for BI reporting
20. Stored procedure for on-demand regional sales reports

## Key Findings
- **Date range:** Orders span from January 2014 to December 2017 — 4 full years of data
- **Regional performance:** West region leads in both total orders (3,203) and 
  total sales (~$725K). Central region has the most orders relative to its profit — 
  worth further investigation
- **Category averages:** Technology averages $452 per order line — nearly 4x more 
  than Office Supplies at $119. Reflects high-ticket items like laptops and phones
- **Discount impact — CRITICAL FINDING:** Medium discount orders (21-40%) generate 
  NEGATIVE average profit (-$8.32). High discount orders (over 40%) lose an average 
  of -$56.78 per order line. The company is losing money on heavily discounted orders — 
  the discount strategy needs urgent review
- **Profit tiers:** 2,133 orders (21% of all orders) generated a total loss of 
  -$155,965. Only 890 high-profit orders generated $300,175 — showing a highly 
  skewed profit distribution
- **Furniture profitability:** Furniture consistently shows the lowest profit margin 
  across ALL regions — likely due to high shipping costs and frequent discounting. 
  Average profit of just $3 per order (CEILING result)
- **Top product:** Canon imageCLASS 2200 Advanced Copier is the #1 ranked product 
  by sales in multiple regions
- **Declining customers:** Sean Miller showed the steepest decline — from $23,661 
  to $837 between orders (-$22,823). A key retention flag for the sales team
- **Monthly trend:** March consistently shows strong sales spikes across years — 
  suggesting seasonal patterns worth further analysis
- **Stored procedure:** usp_RegionalSalesReport allows analysts to pull any region's 
  performance with a single EXEC call — eliminates repetitive query rewriting

## Assumptions Made
- Discount tiers defined as: No Discount (0%), Low (1-20%), Medium (21-40%), 
  High (40%+) based on exploratory data analysis and standard retail discount practices
- Profit tiers defined as: High Profit (>$100), Low Profit ($1-$100), 
  Break Even ($0), Loss (negative) based on logical business breakpoints
- Duplicate detection based on matching Order_ID, Product_ID, and Sales amount

## Technical Notes
- CEILING vs ROUND: CEILING always rounds up regardless of decimal value — 
  used for conservative profit estimates (e.g. Furniture $2.13 → $3, not $2)
- CONVERT style code 101 = MM/DD/YYYY (American date format)
- DATENAME(month, date) returns full month name as text vs MONTH() which returns a number
- Running total (Query 13) requires a CTE to first combine multiple daily orders 
  into one row per date — otherwise SUM() OVER calculates incorrectly
- LAG(value, 1) looks back exactly one row within each customer's order history
- IS NOT NULL filter in Query 15 removes first-ever orders which have no 
  previous order to compare against
- CREATE VIEW saves query logic as a reusable virtual table — analysts can 
  query it without knowing the underlying table structure
- CREATE PROCEDURE with @Region parameter allows on-demand filtering — 
  eliminates repetitive SQL rewriting for weekly regional reports

## Skills Demonstrated
- **Basic:** SELECT, WHERE, ORDER BY, DISTINCT, TOP
- **Aggregations:** MIN, MAX, COUNT, SUM, AVG, ROUND, CEILING
- **String functions:** CONCAT, REPLACE
- **Date functions:** CONVERT (style codes), CAST, DATENAME, YEAR, MONTH
- **Conditional logic:** CASE WHEN, BETWEEN
- **Filtering:** WHERE, HAVING, IS NOT NULL
- **Data cleaning:** DELETE duplicates with ROW_NUMBER CTE pattern
- **CTEs:** Single CTE, chained CTEs, CTE joined back to main table
- **Window functions:** DENSE_RANK, ROW_NUMBER, LAG, SUM() OVER (running total)
- **PARTITION BY** for group-level ranking and calculations
- **CREATE VIEW** for reusable BI reporting
- **CREATE PROCEDURE** with input parameters for on-demand reports
