-- 1. Common Table Expression (CTE): Countries with high CO2 emissions
WITH HighCO2 AS (
  SELECT country, co2_per_person
  FROM countrystats
  WHERE year = 2020 AND co2_per_person > 8
)
SELECT * FROM HighCO2 ORDER BY co2_per_person DESC;


-- 2. Window Function: Rank countries by debt
SELECT 
  country,
  debt_amount,
  RANK() OVER (ORDER BY debt_amount DESC) AS debt_rank
FROM countrystats
WHERE year = 2020;


-- 3. CASE Expression: Categorize CO2 emissions
SELECT 
  country,
  co2_per_person,
  CASE 
    WHEN co2_per_person >= 10 THEN 'High'
    WHEN co2_per_person >= 5 THEN 'Medium'
    ELSE 'Low'
  END AS emission_category
FROM countrystats
WHERE year = 2020;


-- 4. Subquery in SELECT: Compare each country's CO2 to average
SELECT 
  country,
  co2_per_person,
  (SELECT AVG(co2_per_person) FROM countrystats WHERE year = 2020) AS avg_co2
FROM countrystats
WHERE year = 2020;


-- 5. GROUP BY ROLLUP: Aggregate debt by currency and year
SELECT debt_currency, year, SUM(debt_amount)
FROM countrystats
GROUP BY ROLLUP (debt_currency, year);