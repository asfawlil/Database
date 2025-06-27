/* -----------------------------------------------------------------------------
   FILE:    4_complex_queries.sql
   PURPOSE: Complex example queries for economic data:
            1) Countries with high inflation and their GDP
            2) Average GDP per currency for 2023
            3) Top GDP country per currency group for 2023
   SCHEMA:  student32 (Economy Project)
   AUTHOR:  Njomza Bytyqi (student32 / 330021)
----------------------------------------------------------------------------- */

-- ----------------------------------------------------------------------------
-- 1) Countries with inflation > 5% in 2023 and their GDP (local currency)
--    • Joins: inflation → gdp → country_economy
--    • Filters: year = 2023, rate > 5.0
--    • Order by descending inflation rate
-- ----------------------------------------------------------------------------
SELECT
  i.country_code,
  ce.name           AS country_name,
  i.rate            AS inflation_rate,
  g.amount          AS gdp_local_billion
FROM
  student32.inflation        AS i
  JOIN student32.gdp          AS g
    ON i.country_code = g.country_code
   AND i.year         = g.year
  JOIN student32.country_economy AS ce
    ON i.country_code = ce.code
WHERE
  i.year = 2023
  AND i.rate > 5.0
ORDER BY
  i.rate DESC;


-- ----------------------------------------------------------------------------
-- 2) Average GDP for 2023 per currency
--    • Join: gdp → currency
--    • Aggregation: AVG(amount)
--    • Round to two decimal places
-- ----------------------------------------------------------------------------
SELECT
  g.currency_code,
  c.name                 AS currency_name,
  ROUND(AVG(g.amount), 2) AS avg_gdp
FROM
  student32.gdp      AS g
  JOIN student32.currency AS c
    ON g.currency_code = c.code
WHERE
  g.year = 2023
GROUP BY
  g.currency_code,
  c.name
ORDER BY
  g.currency_code;


-- ----------------------------------------------------------------------------
-- 3) Country with the highest GDP in 2023 for each currency group
--    • Correlated subquery to find MAX(amount) per currency
-- ----------------------------------------------------------------------------
SELECT
  g.currency_code,
  g.country_code,
  g.amount
FROM
  student32.gdp AS g
WHERE
  g.year = 2023
  AND g.amount = (
    SELECT
      MAX(g2.amount)
    FROM
      student32.gdp AS g2
    WHERE
      g2.year          = 2023
      AND g2.currency_code = g.currency_code
  )
ORDER BY
  g.currency_code;

