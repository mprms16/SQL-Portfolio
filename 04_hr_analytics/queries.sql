-- =============================================
-- Project 4: HR Analytics
-- Database: HRAnalyticsDB (IBM HR Attrition Dataset)
-- Author: Maria Ramos
-- =============================================


-- Query 1: Employee Count by Department
-- Business Question: How many employees are in each department?
-- Concepts: GROUP BY, COUNT, ORDER BY

SELECT
    Department,
    COUNT(*)    AS EmployeeCount
FROM Employees
GROUP BY Department
ORDER BY EmployeeCount DESC;


-- Query 2: Average Monthly Income by Department
-- Business Question: How are salaries distributed across departments?
-- Concepts: GROUP BY, AVG, ROUND, ORDER BY

SELECT
    Department,
    ROUND(AVG(MonthlyIncome), 2)    AS AvgMonthlyIncome
FROM Employees
GROUP BY Department
ORDER BY AvgMonthlyIncome DESC;


-- Query 3: Attrition Rate by Department
-- Business Question: Which departments are losing the most employees?
-- Concepts: GROUP BY, COUNT, COUNT(CASE WHEN), percentage calculation
-- Note: Multiplying by 100.0 (not 100) forces decimal division
--       to avoid SQL Server integer division truncating results

SELECT
    Department,
    COUNT(*)                                                    AS TotalEmployees,
    COUNT(CASE WHEN Attrition = 'Yes' THEN 1 END)              AS EmployeesLeft,
    ROUND(
        COUNT(CASE WHEN Attrition = 'Yes' THEN 1 END) * 100.0
        / COUNT(*), 2
    )                                                           AS AttritionRate
FROM Employees
GROUP BY Department
ORDER BY AttritionRate DESC;


-- Query 4: Job Roles with Highest Average Monthly Income
-- Business Question: Which job roles command the highest salaries?
-- Concepts: GROUP BY, AVG, ROUND, HAVING, ORDER BY

SELECT
    JobRole,
    COUNT(*)                        AS TotalEmployees,
    ROUND(AVG(MonthlyIncome), 2)    AS AvgMonthlyIncome
FROM Employees
GROUP BY JobRole
HAVING COUNT(*) > 50
ORDER BY AvgMonthlyIncome DESC;


-- Query 5: Overtime vs Attrition Rate
-- Business Question: Do employees who work overtime leave more often?
-- Concepts: GROUP BY, COUNT, COUNT(CASE WHEN), percentage calculation

SELECT
    OverTime,
    COUNT(*)                                                    AS TotalEmployees,
    COUNT(CASE WHEN Attrition = 'Yes' THEN 1 END)              AS EmployeesLeft,
    ROUND(
        COUNT(CASE WHEN Attrition = 'Yes' THEN 1 END) * 100.0
        / COUNT(*), 2
    )                                                           AS AttritionRate
FROM Employees
GROUP BY OverTime
ORDER BY AttritionRate DESC;


-- Query 6: Rank Employees by Income Within Each Department
-- Business Question: How do employees rank against peers in their department?
-- Concepts: CTE, DENSE_RANK, PARTITION BY

WITH EmployeeSalaries AS (
    SELECT
        EmployeeNumber,
        Department,
        JobRole,
        MonthlyIncome
    FROM Employees
)
SELECT
    EmployeeNumber,
    Department,
    JobRole,
    MonthlyIncome,
    DENSE_RANK() OVER (
        PARTITION BY Department
        ORDER BY MonthlyIncome DESC
    ) AS DepartmentRank
FROM EmployeeSalaries
ORDER BY Department, DepartmentRank;


-- Query 7: Employees Earning Below Their Job Role Average
-- Business Question: Which employees are underpaid compared to peers in the same role?
-- Concepts: CTE, AVG, GROUP BY, JOIN CTE back to main table, WHERE filter

WITH JobRoleAvg AS (
    SELECT
        JobRole,
        ROUND(AVG(MonthlyIncome), 2)    AS AvgIncome
    FROM Employees
    GROUP BY JobRole
)
SELECT
    e.EmployeeNumber,
    e.JobRole,
    e.MonthlyIncome                     AS EmployeeIncome,
    j.AvgIncome                         AS JobRoleAvgIncome,
    ROUND(j.AvgIncome
          - e.MonthlyIncome, 2)         AS BelowAvgBy
FROM Employees e
JOIN JobRoleAvg j
    ON e.JobRole = j.JobRole
WHERE e.MonthlyIncome < j.AvgIncome
ORDER BY BelowAvgBy DESC;
