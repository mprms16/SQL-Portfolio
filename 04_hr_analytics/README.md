# Project 4: HR Analytics
**Database:** HRAnalyticsDB  
**Source:** IBM HR Analytics Attrition Dataset (Kaggle) — 1,470 employees  
**Tools:** SQL Server Management Studio 22, T-SQL  

## Overview
This project analyzes employee data from IBM's HR dataset to uncover patterns 
in attrition, compensation, and workforce distribution. It answers key people 
analytics questions that HR directors and compensation teams face daily.

## Business Questions Answered
1. How many employees are in each department?
2. How are salaries distributed across departments?
3. Which departments have the highest attrition rates?
4. Which job roles command the highest average salaries?
5. Does working overtime correlate with higher attrition?
6. How do employees rank by salary within their department?
7. Which employees earn below their job role's average salary?

## Key Findings
- **Department size:** Research & Development is the largest department with 961 
  employees (65% of workforce). Human Resources is the smallest at just 63 employees — 
  typical for a mid-size company where HR is a support function
- **Salary by department:** Despite being the smallest department, Human Resources 
  has the highest average monthly income — common where HR leadership roles 
  carry senior-level compensation
- **Attrition rates:** Sales has the highest attrition rate at ~20.63% — nearly 
  1 in 5 employees left. Research & Development is the most stable at ~13.84%. 
  This is realistic — Sales roles typically have higher turnover due to 
  performance pressure and commission-based compensation
- **CRITICAL FINDING — Overtime and attrition:** Employees working overtime leave 
  at nearly 3x the rate of non-overtime employees (30.53% vs 10.44%). 
  This strongly suggests overtime is a significant driver of employee burnout 
  and turnover — a key actionable insight for HR leadership
- **Highest paying role:** Manager leads all job roles in average monthly income 
  at ~$17,181, followed by Research Director at ~$15,947
- **Salary filter note:** Query 4 filters to roles with more than 50 employees 
  to ensure statistically meaningful averages

## Technical Notes
- Integer division gotcha: percentage calculations use * 100.0 (not * 100) 
  to force decimal division — SQL Server truncates integer division results
- Data types changed from SSMS auto-detected nvarchar/smallint to varchar/int 
  for storage efficiency and to prevent overflow errors in salary calculations
- DENSE_RANK chosen over RANK to avoid confusing gaps when employees share 
  the same monthly income

## Skills Demonstrated
- Aggregations: COUNT, SUM, AVG, ROUND
- Conditional aggregation: COUNT(CASE WHEN...)
- Percentage calculations with integer division handling (100.0 trick)
- HAVING for post-aggregation filtering
- Common Table Expressions (CTEs)
- Window functions: DENSE_RANK() with PARTITION BY
- CTE joined back to main table for row-level salary comparisons
