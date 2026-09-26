-- ====================================================================
-- PROJECT 2: IBM HR EMPLOYEE ATTRITION ANALYSIS
-- FILE: queries.sql
-- ====================================================================

-- Q1: Attrition rate by department
SELECT Department, COUNT(*) AS total,
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS left_count,
       ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_pct
FROM hr_table
GROUP BY Department
ORDER BY attrition_pct DESC;

-- Q2: Impact of monthly salary bands on retention
SELECT
  CASE
    WHEN MonthlyIncome < 3000 THEN 'Low (under 3k)'
    WHEN MonthlyIncome BETWEEN 3000 AND 6000 THEN 'Mid (3k-6k)'
    WHEN MonthlyIncome BETWEEN 6000 AND 12000 THEN 'Upper Mid (6k-12k)'
    ELSE 'High (12k+)'
  END AS salary_band,
  COUNT(*) AS employees,
  ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_pct
FROM hr_table
GROUP BY salary_band
ORDER BY attrition_pct DESC;

-- Q3: Overtime workload impact on turnover
SELECT OverTime, COUNT(*) AS employees,
       ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_pct
FROM hr_table
GROUP BY OverTime;

-- Q4: Job satisfaction survey metrics vs attrition
SELECT JobSatisfaction,
       CASE JobSatisfaction WHEN 1 THEN 'Low' WHEN 2 THEN 'Medium' WHEN 3 THEN 'High' WHEN 4 THEN 'Very High' END AS satisfaction_label,
       COUNT(*) AS employees,
       ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_pct
FROM hr_table
GROUP BY JobSatisfaction;

-- Q5: Work-life balance impact metrics
SELECT WorkLifeBalance,
       CASE WorkLifeBalance WHEN 1 THEN 'Bad' WHEN 2 THEN 'Good' WHEN 3 THEN 'Better' WHEN 4 THEN 'Best' END AS wlb_label,
       COUNT(*) AS employees,
       ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_pct
FROM hr_table
GROUP BY WorkLifeBalance;

-- Q6: Generational age group analysis
SELECT
  CASE WHEN Age < 25 THEN 'Under 25' WHEN Age BETWEEN 25 AND 35 THEN '25-35' WHEN Age BETWEEN 35 AND 45 THEN '35-45' ELSE 'Over 45' END AS age_group,
  COUNT(*) AS employees,
  ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_pct
FROM hr_table
GROUP BY age_group
ORDER BY attrition_pct DESC;

-- Q7: Career stagnation (Years since promotion) impact
SELECT
  CASE WHEN YearsSinceLastPromotion = 0 THEN 'Just promoted' WHEN YearsSinceLastPromotion BETWEEN 1 AND 2 THEN '1-2 years' WHEN YearsSinceLastPromotion BETWEEN 3 AND 5 THEN '3-5 years' ELSE 'Over 5 years' END AS promotion_gap,
  COUNT(*) AS employees,
  ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_pct
FROM hr_table
GROUP BY promotion_gap
ORDER BY attrition_pct DESC;

-- Q8: Granular profile isolation of high-risk operational segments
SELECT Department, JobRole, OverTime,
  ROUND(AVG(MonthlyIncome), 0) AS avg_salary,
  COUNT(*) AS employees,
  ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_pct
FROM hr_table
GROUP BY Department, JobRole, OverTime
HAVING COUNT(*) >= 10
ORDER BY attrition_pct DESC
LIMIT 5;
