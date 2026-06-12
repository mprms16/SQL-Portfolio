-- =============================================
-- Project 3: Healthcare Analysis
-- Database: HealthcareDB (Kaggle Healthcare Dataset)
-- Author: Maria Ramos
-- =============================================

-- DATA CLEANING PERFORMED:
-- Name column had inconsistent capitalization (e.g. 'bObBy jAcKsOn')
-- Step 1: Fixed to lowercase using UPDATE SET Name = LOWER(Name)
-- Step 2: Fixed to Proper Case using UPPER/LOWER/SUBSTRING:
--
-- UPDATE Patients
-- SET Name =
--     UPPER(LEFT(Name, 1)) +
--     LOWER(SUBSTRING(Name, 2, CHARINDEX(' ', Name) - 1)) +
--     ' ' +
--     UPPER(SUBSTRING(Name, CHARINDEX(' ', Name) + 1, 1)) +
--     LOWER(SUBSTRING(Name, CHARINDEX(' ', Name) + 2, LEN(Name)));
--
-- This reflects a common real-world data quality issue in healthcare systems


-- Query 1: Patient Count by Medical Condition
-- Business Question: How many patients are affected by each condition?
-- Concepts: GROUP BY, COUNT, ORDER BY

SELECT
    Medical_Condition           AS MedCondition,
    COUNT(*)                    AS PatientCount
FROM Patients
GROUP BY Medical_Condition
ORDER BY PatientCount DESC;


-- Query 2: Average Billing per Insurance Provider
-- Business Question: How does billing vary across insurance providers?
-- Concepts: GROUP BY, AVG, ROUND, ORDER BY

SELECT
    Insurance_Provider,
    ROUND(AVG(Billing_Amount), 2)   AS AvgBillingAmount
FROM Patients
GROUP BY Insurance_Provider
ORDER BY AvgBillingAmount DESC;


-- Query 3: Patient Volume and Billing by Admission Type
-- Business Question: What is the patient volume and total billing by admission type?
-- Concepts: GROUP BY, COUNT, SUM, ROUND

SELECT
    Admission_Type,
    COUNT(*)                        AS TotalNumberPatients,
    ROUND(SUM(Billing_Amount), 2)   AS TotalBillingAmount
FROM Patients
GROUP BY Admission_Type
ORDER BY TotalBillingAmount DESC;


-- Query 4: Abnormal Test Results by Medical Condition
-- Business Question: Which conditions produce the most abnormal test results?
-- Concepts: GROUP BY, COUNT, COUNT(CASE WHEN), HAVING

SELECT
    Medical_Condition,
    COUNT(*)                                                AS TotalPatients,
    COUNT(CASE WHEN Test_Results = 'Abnormal' THEN 1 END)  AS AbnormalResults
FROM Patients
GROUP BY Medical_Condition
HAVING COUNT(CASE WHEN Test_Results = 'Abnormal' THEN 1 END) > 1000
ORDER BY AbnormalResults DESC;


-- Query 5: Average Length of Hospital Stay per Condition
-- Business Question: Which conditions require the longest average hospital stay?
-- Concepts: DATEDIFF, AVG, ROUND, GROUP BY

SELECT
    Medical_Condition,
    ROUND(AVG(DATEDIFF(day, Date_of_Admission, Discharge_Date)), 1) AS AvgLengthStay
FROM Patients
GROUP BY Medical_Condition
ORDER BY AvgLengthStay DESC;


-- Query 6: Rank Doctors by Total Revenue Generated
-- Business Question: Which doctors generate the most revenue?
-- Concepts: CTE, SUM, COUNT, DENSE_RANK

WITH DoctorRevenue AS (
    SELECT
        Doctor,
        COUNT(*)                        AS TotalPatients,
        ROUND(SUM(Billing_Amount), 2)   AS TotalRevenue
    FROM Patients
    GROUP BY Doctor
)
SELECT
    Doctor,
    TotalPatients,
    TotalRevenue,
    DENSE_RANK() OVER (ORDER BY TotalRevenue DESC) AS RevenueRank
FROM DoctorRevenue
ORDER BY RevenueRank;


-- Query 7: Patients Billed Above Their Condition's Average
-- Business Question: Which patients were charged more than the average for their condition?
-- Concepts: CTE, AVG, GROUP BY, JOIN CTE back to main table, WHERE filter

WITH ConditionAvg AS (
    SELECT
        Medical_Condition,
        ROUND(AVG(Billing_Amount), 2)   AS AvgBilling
    FROM Patients
    GROUP BY Medical_Condition
)
SELECT
    p.Name,
    p.Medical_Condition,
    ROUND(p.Billing_Amount, 2)          AS PatientBilling,
    ca.AvgBilling                       AS ConditionAvgBilling,
    ROUND(p.Billing_Amount
          - ca.AvgBilling, 2)           AS DifferenceAboveAvg
FROM Patients p
JOIN ConditionAvg ca
    ON p.Medical_Condition = ca.Medical_Condition
WHERE p.Billing_Amount > ca.AvgBilling
ORDER BY DifferenceAboveAvg DESC;
