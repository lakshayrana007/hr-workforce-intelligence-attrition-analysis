-- =====================================================
-- HR WORKFORCE INTELLIGENCE & RISK ANALYTICS
-- FILE: hr_advanced_analysis.sql
-- PURPOSE: Advanced Attrition Diagnostics, Risk Modeling 
--          & Financial Impact Analysis
-- =====================================================


-- =====================================================
-- SECTION 1: PROMOTION & STAGNATION ANALYSIS
-- =====================================================

-- KPI 1: Avg Years Since Last Promotion (Attrition vs Active)

SELECT
    attrition,
    COUNT(*) as total_employees,
    ROUND(AVG(years_since_last_promotion),2)
    as avg_yrs_since_promotion
FROM hr_employee_data
GROUP BY attrition;


-- KPI 2: Promotion Gap Buckets

SELECT
    CASE 
        WHEN years_since_last_promotion <= 2 THEN '0-2 Years'  
        WHEN years_since_last_promotion BETWEEN 3 AND 5 THEN '3-5 Years'
        ELSE '6+ Years' 
    END as promotion_gap_buckets,
    COUNT(*) as total_employees,
    SUM(attrition = 'Yes') as attrited_employees,
    ROUND(SUM(attrition = 'Yes') * 100.0 / COUNT(*) ,2) as attrition_pct
FROM hr_employee_data
GROUP BY promotion_gap_buckets;


-- KPI 3: Stagnation Flag

SELECT
    CASE 
        WHEN years_at_company > 5 AND years_since_last_promotion > 3
        THEN 'Stagnated'  
        ELSE 'Not Stagnated' 
    END as stagnation_flag,
    COUNT(*) as total_employees,
    SUM(attrition = 'Yes') as attrited_employees,
    ROUND(SUM(attrition = 'Yes') * 100.0 / COUNT(*),2)
    as attrition_pct
FROM hr_employee_data
GROUP BY stagnation_flag;


-- =====================================================
-- SECTION 2: EMPLOYEE RISK SCORING MODEL
-- =====================================================

-- KPI 4: Raw Employee Risk Score (Weighted Factors)

SELECT
    emp_id,
    attrition,
    (CASE WHEN over_time = 'Yes' THEN 2 ELSE 0 END + 
     CASE WHEN job_satisfaction <=2 THEN 2 ELSE 0 END +
     CASE WHEN work_life_balance <=2 THEN 2 ELSE 0 END +
     CASE WHEN years_since_last_promotion >3 THEN 1 ELSE 0 END +
     CASE WHEN stock_option_level = 0 THEN 1 ELSE 0 END) as raw_risk_score
FROM hr_employee_data;


-- KPI 5: Risk Bucket Distribution

SELECT
    CASE 
        WHEN raw_risk_score <=2 THEN 'Low Risk' 
        WHEN raw_risk_score BETWEEN 3 AND 5 THEN 'Medium Risk'
        ELSE 'High Risk'
    END as risk_bucket,
    COUNT(emp_id) as total_employees
FROM
    (SELECT
        emp_id,
       (CASE WHEN over_time = 'Yes' THEN 2 ELSE 0 END + 
        CASE WHEN job_satisfaction <=2 THEN 2 ELSE 0 END +
        CASE WHEN work_life_balance <=2 THEN 2 ELSE 0 END +
        CASE WHEN years_since_last_promotion >3 THEN 1 ELSE 0 END +
        CASE WHEN stock_option_level = 0 THEN 1 ELSE 0 END) as raw_risk_score
    FROM hr_employee_data)x
GROUP BY risk_bucket;


-- KPI 6: Model Validation

SELECT
    CASE 
        WHEN raw_risk_score <=2 THEN 'Low Risk' 
        WHEN raw_risk_score BETWEEN 3 AND 5 THEN 'Medium Risk'
        ELSE 'High Risk'
    END as risk_bucket,
    COUNT(emp_id) as total_employees,
    SUM(attrition = 'Yes') AS attrited_employees,
    ROUND(SUM(attrition = 'Yes') * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM
    (SELECT
        *,
       (CASE WHEN over_time = 'Yes' THEN 2 ELSE 0 END +
        CASE WHEN job_satisfaction <=2 THEN 2 ELSE 0 END +
        CASE WHEN work_life_balance <=2 THEN 2 ELSE 0 END +
        CASE WHEN years_since_last_promotion >3 THEN 1 ELSE 0 END +
        CASE WHEN stock_option_level = 0 THEN 1 ELSE 0 END) AS raw_risk_score
    FROM hr_employee_data)x
GROUP BY risk_bucket
ORDER BY attrition_rate_pct DESC;


-- =====================================================
-- SECTION 3: FINANCIAL IMPACT ANALYSIS
-- =====================================================

-- KPI 7: Total Historical Attrition Cost

SELECT
    COUNT(*) as total_attrited_employees,
    SUM(1.5 * monthly_income * 12) as total_attrition_cost
FROM hr_employee_data
WHERE attrition = 'Yes';


-- KPI 8: Salary Exposure of High-Risk Employees

SELECT
    COUNT(*) as high_risk_active_employees,
    SUM(1.5 * monthly_income * 12) as potential_attrition_exposure
FROM    
    (SELECT
        *,
        CASE 
            WHEN raw_risk_score <=2 THEN 'Low Risk' 
            WHEN raw_risk_score BETWEEN 3 AND 5 THEN 'Medium Risk'
            ELSE 'High Risk'
        END as risk_bucket
FROM
    (SELECT
        *,
       (CASE WHEN over_time = 'Yes' THEN 2 ELSE 0 END +
        CASE WHEN job_satisfaction <=2 THEN 2 ELSE 0 END +
        CASE WHEN work_life_balance <=2 THEN 2 ELSE 0 END +
        CASE WHEN years_since_last_promotion >3 THEN 1 ELSE 0 END +
        CASE WHEN stock_option_level = 0 THEN 1 ELSE 0 END) AS raw_risk_score
    FROM hr_employee_data)x)y
WHERE risk_bucket = 'High Risk' AND attrition = 'No';


-- =====================================================
-- SECTION 4: EARLY EXIT & RETENTION INTELLIGENCE
-- =====================================================

-- KPI 9: Overall Early Exit Rate (<= 2 Years)

SELECT
    SUM(attrition = 'Yes') as total_attrited_employees,
    SUM(years_at_company <=2 AND attrition = 'Yes')
    as early_exit_employees,
    ROUND(SUM(years_at_company <=2 AND attrition = 'Yes') * 100.0
    /
    SUM(attrition = 'Yes'),2) as early_exit_pct
FROM hr_employee_data;


-- KPI 10: Early Exit % by Department

SELECT
    department,
    SUM(attrition = 'Yes') as total_attrited_employees,
    SUM(years_at_company <=2 AND attrition = 'Yes')
    as early_exit_employees,
    ROUND(SUM(years_at_company <=2 AND attrition = 'Yes') * 100.0
    /
    SUM(attrition = 'Yes'),2) as early_exit_pct
FROM hr_employee_data
GROUP BY department;


-- =====================================================
-- SECTION 5: EXCEL MODELING EXPORT DATASET
-- =====================================================

-- KPI 11: Row-level dataset for attrition cost & risk modeling

SELECT 
    emp_id,
    department,
    job_role,
    monthly_income,
    years_at_company,
    years_since_last_promotion,
    job_satisfaction,
    work_life_balance,
    over_time,
    attrition,
    risk_bucket
FROM 
    (SELECT 
        *,
        CASE 
            WHEN raw_risk_score <=2 THEN 'Low Risk' 
            WHEN raw_risk_score BETWEEN 3 AND 5 THEN 'Medium Risk'
            ELSE 'High Risk'
        END as risk_bucket
FROM
    (SELECT
        *,
       (CASE WHEN over_time = 'Yes' THEN 2 ELSE 0 END +
        CASE WHEN job_satisfaction <=2 THEN 2 ELSE 0 END +
        CASE WHEN work_life_balance <=2 THEN 2 ELSE 0 END +
        CASE WHEN years_since_last_promotion >3 THEN 1 ELSE 0 END +
        CASE WHEN stock_option_level = 0 THEN 1 ELSE 0 END) AS raw_risk_score
    FROM hr_employee_data)x)y;




-- =====================================================
-- END OF FILE: hr_advanced_analysis.sql
-- Advanced Workforce Intelligence & Risk Modeling Completed
-- =====================================================


