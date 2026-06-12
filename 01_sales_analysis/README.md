# Project 1: Sales Analysis
**Database:** AdventureWorks  
**Tools:** SQL Server Management Studio 22, T-SQL  

## Overview
This project analyzes sales performance at AdventureWorks using order and product data. 
It covers product revenue, category performance, order segmentation, and monthly trends.

## Business Questions Answered
1. Which products generated the most revenue?
2. Which product categories drove the most revenue (over $1M only)?
3. How are orders distributed across Small, Medium, and Large segments?
4. How has monthly revenue trended over time?

## Key Findings
- **Top Product:** Mountain-200 Black, 38 led all products in total revenue at ~$4.3M
- **Top Category:** Bikes dominated category revenue at ~$94M — far ahead of all other categories
- **Order Segments:** The majority of total revenue came from Large orders (over $10,000), showing that high-value B2B or bulk orders drive the business
- **Monthly Trend:** Revenue grew consistently from ~$489K in May 2011 to ~$3.7M in June 2014 — roughly a 7x increase over 3 years. Revenue peaks tend to occur in summer months (June–August) each year
- **Data Note:** Some customers are businesses without a person record attached — LEFT JOIN used to handle NULL names gracefully

## Skills Demonstrated
- Multi-table JOINs (up to 4 tables)
- Aggregations with GROUP BY and HAVING
- Conditional logic with CASE WHEN for order segmentation
- Date functions: YEAR(), MONTH()
- Revenue filtering with HAVING
