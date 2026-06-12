# Project 2: Customer Insights
**Database:** AdventureWorks  
**Tools:** SQL Server Management Studio 22, T-SQL  

## Overview
This project dives into customer behavior, territory performance, and customer value 
segmentation at AdventureWorks. It introduces CTEs and window functions to answer 
more complex business questions about customer ranking and loyalty risk.

## Business Questions Answered
1. Who are the top 20 customers by lifetime revenue?
2. How does each sales territory perform in orders and revenue?
3. What is the average order value per customer (more than 3 orders)?
4. Which customers have placed only one order — loyalty risk? (two approaches shown)
5. How do customers break down into Platinum, Gold, and Silver tiers?
6. How do customers rank by revenue within their own territory?
7. Who are the top 3 customers in each territory?

## Key Findings
- **NULL customers at top:** Some top revenue generators are business accounts without 
  a person record — LEFT JOIN used intentionally to retain these rows. 
  This is a real-world data quality pattern common in B2B databases
- **Territory performance:** Southwest territory led in total revenue, 
  while some smaller territories showed strong average order values
- **Loyalty risk:** A significant number of customers placed only one order — 
  a key retention opportunity for the marketing team
- **Customer tiers:** Platinum customers (over $50K lifetime) represent a small 
  percentage of customers but drive a disproportionate share of revenue
- **Two solutions shown for Query 4:** HAVING COUNT = 1 and subquery with WHERE IN — 
  demonstrating multiple approaches to the same business problem

## Technical Notes
- LEFT JOIN to Person.Person used throughout — some customers are businesses 
  with no PersonID, a regular JOIN would silently drop these rows and skew results
- Query 4 demonstrates two valid approaches: HAVING vs subquery
- DENSE_RANK chosen over RANK to avoid confusing gaps in territory rankings

## Skills Demonstrated
- Multi-table LEFT JOINs (up to 4 tables)
- Aggregations: COUNT, SUM, AVG, ROUND
- HAVING for post-aggregation filtering
- Subqueries with WHERE IN
- Common Table Expressions (CTEs)
- Chained CTEs (CTE building on CTE)
- Window functions: DENSE_RANK() with PARTITION BY
- Top-N filtering per group using WHERE rank <= N
