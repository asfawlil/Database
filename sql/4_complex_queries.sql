-- This query calculates the Z-score for each country's debt amount in 2020.
-- A higher Z-score means the country's debt is significantly above average.
WITH stats AS (
  SELECT 
    AVG(debt_amount) AS avg_debt,
    STDDEV(debt_amount) AS std_dev
  FROM countrystats
  WHERE year = 2020
)
SELECT 
  cs.country,
  cs.debt_amount,
  ROUND((cs.debt_amount - s.avg_debt) / s.std_dev, 2) AS z_score
FROM countrystats cs, stats s
WHERE year = 2020
ORDER BY z_score DESC;

-- This query calculates the total debt for each currency in 2020.
SELECT debt_currency,
       SUM(debt_amount) AS total_debt
FROM countrystats
WHERE year = 2020
GROUP BY debt_currency
ORDER BY total_debt DESC;


-- This query ranks countries by their CO2 emissions per person in 2020.
SELECT 
  country,
  co2_per_person,
  RANK() OVER (ORDER BY co2_per_person DESC) AS emission_rank
FROM countrystats
WHERE year = 2020;