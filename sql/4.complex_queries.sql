-- ---------------------------------------------------------------
-- Complex Labor Market Analysis
-- Author: Liliana Asfaw (student38)
-- Goal: Analyze and compare labor-related indicators 
--       such as unemployment rate, average salary, and minimum wage
-- ---------------------------------------------------------------

-- Query 1: Minimum wage as a percentage of average salary
-- Goal: What percentage of the average salary is the minimum wage?
-- Extended with classification below/above the global average

-- Use CTE for modular logic and reusability
-- Calculates global average salary across all countries and years
WITH global_avg AS (
  SELECT ROUND(AVG(amount), 2) AS avg_global_salary
  FROM student38.average_salary
  WHERE amount IS NOT NULL                         -- Exclude incomplete data
)
SELECT 
  a.country_name,                                  -- Human-readable country name
  m.year,                                          -- Year of record
  m.amount AS min_wage,                            -- Minimum wage for that year and country
  a.amount AS avg_salary,                          -- Corresponding average salary
  ROUND((m.amount / a.amount) * 100, 2) AS min_wage_percent,  -- Relative share in %
  CASE                                             -- Classification vs global average
    WHEN a.amount < g.avg_global_salary THEN 'Below global average'
    WHEN a.amount > g.avg_global_salary THEN 'Above global average'
    ELSE 'Exactly on the global average'
  END AS salary_level_global
FROM student38.minimum_wage m
JOIN student38.average_salary a 
  ON m.country_code = a.country_code AND m.year = a.year  -- Ensures same country and year
CROSS JOIN global_avg g                                   -- Static join to reference average
WHERE m.amount IS NOT NULL AND a.amount IS NOT NULL       -- Data completeness check
ORDER BY min_wage_percent DESC;                           -- Ranking: highest share on top

-- Query 2: Economically strained countries
-- Goal: Combination of high unemployment & low average salary
-- Result: Classification as "Critical", "Strained", or "Moderate"

-- Use thresholds and CASE logic for clear categorization
-- Integrates two key dimensions for economic stress evaluation
SELECT 
  u.country_name,                            -- Country
  u.year,                                    -- Year
  u.unemployment_rate,                       -- Unemployment indicator
  a.amount AS avg_salary,                    -- Average salary
  CASE                                       -- Risk classification based on thresholds
    WHEN u.unemployment_rate > 10 AND a.amount < 30000 THEN 'Critical'
    WHEN u.unemployment_rate > 6 AND a.amount < 40000 THEN 'Strained'
    ELSE 'Moderate'
  END AS risk_level                          -- Combined risk level
FROM student38.unemployment u
JOIN student38.average_salary a 
  ON u.country_code = a.country_code AND u.year = a.year  -- Data join by country and year
WHERE u.unemployment_rate IS NOT NULL
  AND a.amount IS NOT NULL                                -- Ensures meaningful classification
ORDER BY risk_level DESC, u.unemployment_rate DESC;       -- Prioritize highest risk first

-- Query 3: Countries with above-average minimum wage
-- Goal: Identify countries whose minimum wage is above the yearly average
-- Technique: CTE to calculate annual average and determine difference

-- Use CTE to precompute yearly averages and enable performance-friendly joins
WITH avg_per_year AS (
  SELECT 
    year, 
    ROUND(AVG(amount), 2) AS avg_min_wage_year           -- Compute annual average wage
  FROM student38.minimum_wage
  WHERE amount IS NOT NULL
  GROUP BY year                                          -- Enables year-specific comparison
)
SELECT 
  m.country_name,
  m.year,
  m.amount AS min_wage,
  y.avg_min_wage_year,                                   -- Reference value from the CTE
  ROUND(m.amount - y.avg_min_wage_year, 2) AS above_average_by  -- Deviation from average
FROM student38.minimum_wage m
JOIN avg_per_year y 
  ON m.year = y.year                                     -- Join ensures year-matched comparison
WHERE m.amount > y.avg_min_wage_year                     -- Filter only those above average
ORDER BY m.year DESC, above_average_by DESC              -- Sorted by most recent and highest excess
LIMIT 5;                                                 -- Limit result for digestible output
