-- ---------------------------------------------------------------
-- Complex Labor Market Analysis
-- Author: Liliana Asfaw (student38)
-- Goal: Analyze and compare labor-related indicators 
--       such as unemployment rate, average salary, and minimum wage
-- ---------------------------------------------------------------

-- Query 1: Minimum wage as a percentage of average salary
-- Goal: What percentage of the average salary is the minimum wage?
-- Extended with classification below/above the global average
WITH global_avg AS (
  SELECT ROUND(AVG(amount), 2) AS avg_global_salary
  FROM student38.average_salary
  WHERE amount IS NOT NULL
)
SELECT 
  a.country_name,
  m.year,
  m.amount AS min_wage,
  a.amount AS avg_salary,
  ROUND((m.amount / a.amount) * 100, 2) AS min_wage_percent,
  CASE 
    WHEN a.amount < g.avg_global_salary THEN 'Below global average'
    WHEN a.amount > g.avg_global_salary THEN 'Above global average'
    ELSE 'Exactly on the global average'
  END AS salary_level_global
FROM student38.minimum_wage m
JOIN student38.average_salary a 
  ON m.country_code = a.country_code AND m.year = a.year
CROSS JOIN global_avg g
WHERE m.amount IS NOT NULL AND a.amount IS NOT NULL
ORDER BY min_wage_percent DESC;

-- Query 2: Economically strained countries
-- Goal: Combination of high unemployment & low average salary
-- Result: Classification as "Critical", "Strained", or "Moderate"
SELECT 
  u.country_name,
  u.year,
  u.unemployment_rate,
  a.amount AS avg_salary,
  CASE
    WHEN u.unemployment_rate > 10 AND a.amount < 30000 THEN 'Critical'
    WHEN u.unemployment_rate > 6 AND a.amount < 40000 THEN 'Strained'
    ELSE 'Moderate'
  END AS risk_level
FROM student38.unemployment u
JOIN student38.average_salary a 
  ON u.country_code = a.country_code AND u.year = a.year
WHERE u.unemployment_rate IS NOT NULL
  AND a.amount IS NOT NULL
ORDER BY risk_level DESC, u.unemployment_rate DESC;

-- Query 3: Countries with above-average minimum wage
-- Goal: Identify countries whose minimum wage is above the yearly average
-- Technique: CTE to calculate annual average and determine difference
WITH avg_per_year AS (
  SELECT 
    year, 
    ROUND(AVG(amount), 2) AS avg_min_wage_year
  FROM student38.minimum_wage
  WHERE amount IS NOT NULL
  GROUP BY year
)
SELECT 
  m.country_name,
  m.year,
  m.amount AS min_wage,
  y.avg_min_wage_year,
  ROUND(m.amount - y.avg_min_wage_year, 2) AS above_average_by
FROM student38.minimum_wage m
JOIN avg_per_year y 
  ON m.year = y.year
WHERE m.amount > y.avg_min_wage_year
ORDER BY m.year DESC, above_average_by DESC
LIMIT 5;
