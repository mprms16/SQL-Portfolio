# Project 3: Healthcare Analysis
**Database:** HealthcareDB  
**Source:** Kaggle Healthcare Dataset — 55,500 patients  
**Tools:** SQL Server Management Studio 22, T-SQL  

## Overview
This project analyzes patient data, hospital billing, and clinical outcomes 
across a healthcare dataset. It covers patient demographics, medical conditions, 
billing patterns, and doctor performance using a real-world public dataset.

## Data Cleaning Performed
- Name column had severely inconsistent capitalization (e.g. 'bObBy jAcKsOn', 'LesLie TErRy')
- Fixed in two steps: first normalized to lowercase, then rebuilt Proper Case 
  using UPPER/LOWER/SUBSTRING functions
- This reflects a common real-world data quality issue in healthcare systems 
  where data is entered manually across multiple platforms

## Business Questions Answered
1. How many patients are affected by each medical condition?
2. How does average billing vary across insurance providers?
3. What is the patient volume and total billing by admission type?
4. Which conditions produce the most abnormal test results?
5. Which conditions require the longest average hospital stay?
6. Which doctors generate the most revenue?
7. Which patients were billed above their condition's average?

## Key Findings
- **Condition distribution:** All 6 conditions (Diabetes, Hypertension, Arthritis, 
  Obesity, Cancer, Asthma) are evenly distributed at ~9,200 patients each — 
  typical of a synthetic dataset. In real healthcare data, chronic conditions 
  like Hypertension and Diabetes would dominate
- **Billing by insurance:** Billing amounts are similar across all 5 providers — 
  again reflecting synthetic data. In real data, significant variation would 
  exist based on negotiated rates
- **Admission types:** Emergency, Urgent, and Elective admissions are evenly 
  split at ~18,000 patients each. Real data would show Emergency skewing higher
- **Abnormal test results:** All conditions exceeded 3,000 abnormal results — 
  worth flagging for clinical quality review
- **Length of stay:** Average stay is consistent at ~15 days across all conditions — 
  a data limitation noted. Real data shows Cancer and Emergency cases staying 
  significantly longer than Arthritis or Asthma
- **Data limitation note:** This is synthetic data — findings show balanced 
  distributions not typical of real healthcare systems. Noted in analysis

## Technical Notes
- COUNT(*) used for total patients — counts all rows regardless of NULL values
- COUNT(CASE WHEN Test_Results = 'Abnormal' THEN 1 END) used for conditional 
  counting — only counts rows meeting the condition
- DATEDIFF(day, Date_of_Admission, Discharge_Date) calculates length of stay
- CTE in Query 7 calculates condition averages first, then joins back to patient 
  table to enable row-level comparison against group averages

## Skills Demonstrated
- Single and multi-table queries
- Aggregations: COUNT, SUM, AVG, ROUND
- Conditional aggregation: COUNT(CASE WHEN...)
- Date math: DATEDIFF()
- Common Table Expressions (CTEs)
- Window functions: DENSE_RANK()
- CTE joined back to main table for row-level comparisons
- Data cleaning: UPDATE with UPPER/LOWER/SUBSTRING
