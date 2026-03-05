-- =====================================================
-- HR WORKFORCE ANALYTICS
-- FILE: hr_basic_analysis.sql
-- PURPOSE: Foundational Workforce & Attrition KPIs
-- =====================================================


-- =====================================================
-- SECTION 1: OVERALL WORKFORCE OVERVIEW
-- =====================================================

-- KPI 1: Total Employees & Overall Attrition Rate

SELECT
    COUNT(*) AS total_employees,
    SUM(attrition = 'Yes') AS attrited_employees,
    ROUND(SUM(attrition = 'Yes') * 100.0 / COUNT(*), 2)
    AS attrition_rate_pct
FROM hr_employee_data;


-- =====================================================
-- SECTION 2: ATTRITION BREAKDOWN
-- =====================================================

-- KPI 2: Attrition by Gender

SELECT
    gender,
    COUNT(*) AS total_employees,
    SUM(attrition = 'Yes') AS attrited_employees,
    ROUND(SUM(attrition = 'Yes') * 100.0 / COUNT(*), 2)
    AS attrition_rate_pct
FROM hr_employee_data
GROUP BY gender;


-- KPI 3: Attrition by Department

SELECT
    department,
    COUNT(*) AS total_employees,
    SUM(attrition = 'Yes') AS attrited_employees,
    ROUND(SUM(attrition = 'Yes') * 100.0 / COUNT(*), 2)
    AS attrition_rate_pct
FROM hr_employee_data
GROUP BY department;


-- KPI 4: Attrition by Job Role

SELECT
    job_role,
    COUNT(*) AS total_employees,
    SUM(attrition = 'Yes') AS attrited_employees,
    ROUND(SUM(attrition = 'Yes') * 100.0 / COUNT(*), 2)
    AS attrition_rate_pct
FROM hr_employee_data
GROUP BY job_role;


-- KPI 5: Attrition by Overtime
SELECT
    over_time,
    COUNT(*) AS total_employees,
    SUM(attrition = 'Yes') AS attrited_employees,
    ROUND(SUM(attrition = 'Yes') * 100.0 / COUNT(*), 2)
    AS attrition_rate_pct
FROM hr_employee_data
GROUP BY over_time;


-- KPI 6: Attrition by Marital Status
SELECT
    marital_status,
    COUNT(*) AS total_employees,
    SUM(attrition = 'Yes') AS attrited_employees,
    ROUND(SUM(attrition = 'Yes') * 100.0 / COUNT(*), 2)
    AS attrition_rate_pct
FROM hr_employee_data
GROUP BY marital_status;


-- KPI 7: Attrition by Education Field
SELECT
    education_field,
    COUNT(*) AS total_employees,
    SUM(attrition = 'Yes') AS attrited_employees,
    ROUND(SUM(attrition = 'Yes') * 100.0 / COUNT(*), 2)
    AS attrition_rate_pct
FROM hr_employee_data
GROUP BY education_field;


-- KPI 8: Attrition by Age Group

SELECT
    CASE 
        WHEN age < 25 THEN 'Under 25'
        WHEN age BETWEEN 25 AND 34 THEN '25-34'
        WHEN age BETWEEN 35 AND 44 THEN '35-44'
        WHEN age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55+'
    END AS age_group,
    COUNT(*) AS total_employees,
    SUM(attrition = 'Yes') AS attrited_employees,
    ROUND(SUM(attrition = 'Yes') * 100.0 / COUNT(*), 2) 
        AS attrition_rate_pct
FROM hr_employee_data
GROUP BY age_group
ORDER BY attrition_rate_pct DESC;


-- =====================================================
-- SECTION 3: SALARY & TENURE SEGMENTATION
-- =====================================================

-- KPI 9: Attrition by Salary Band

SELECT
    CASE 
        WHEN monthly_income <= 7000 THEN 'Low'
        WHEN monthly_income BETWEEN 7001 AND 14000 THEN 'Medium'
        ELSE 'High'
    END AS salary_band,
    COUNT(*) AS total_employees,
    SUM(attrition = 'Yes') AS attrited_employees,
    ROUND(SUM(attrition = 'Yes') * 100.0 / COUNT(*), 2) 
    AS attrition_rate_pct
FROM hr_employee_data
GROUP BY salary_band;


-- KPI 10: Attrition by Tenure Bucket
SELECT
    CASE 
        WHEN years_at_company <= 2 THEN '0-2 Years'
        WHEN years_at_company BETWEEN 3 AND 5 THEN '3-5 Years'
        WHEN years_at_company BETWEEN 6 AND 10 THEN '6-10 Years'
        ELSE '10+ Years'
    END AS tenure_bucket,
    COUNT(*) AS total_employees,
    SUM(attrition = 'Yes') AS attrited_employees,
    ROUND(SUM(attrition = 'Yes') * 100.0 / COUNT(*), 2) 
    AS attrition_rate_pct
FROM hr_employee_data
GROUP BY tenure_bucket;


-- =====================================================
-- SECTION 4: SATISFACTION & WORK FACTORS
-- =====================================================

-- KPI 11: Attrition by Job Satisfaction

SELECT
    job_satisfaction,
    COUNT(*) AS total_employees,
    SUM(attrition = 'Yes') AS attrited_employees,
    ROUND(SUM(attrition = 'Yes') * 100.0 / COUNT(*), 2)
    AS attrition_rate_pct
FROM hr_employee_data
GROUP BY job_satisfaction;


-- KPI 12: Attrition by Work Life Balance

SELECT
    work_life_balance,
    COUNT(*) AS total_employees,
    SUM(attrition = 'Yes') AS attrited_employees,
    ROUND(SUM(attrition = 'Yes') * 100.0 / COUNT(*), 2)
    AS attrition_rate_pct
FROM hr_employee_data
GROUP BY work_life_balance;


-- =====================================================
-- END OF FILE: hr_basic_analysis.sql
-- Foundational Workforce & Attrition Analysis Completed
-- =====================================================