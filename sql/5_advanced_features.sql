
SELECT country, 
       export_amount, 
       import_amount, 
       ABS(export_amount - import_amount) AS trade_gap
FROM country_trade_industry
WHERE year = 2023
ORDER BY trade_gap ASC
LIMIT 3;


SELECT country, 
       industry_share_percent, 
       export_amount
FROM country_trade_industry
WHERE year = 2023
ORDER BY industry_share_percent DESC, export_amount ASC
LIMIT 3;



SELECT country, export_products, import_products
FROM country_trade_industry
WHERE year = 2023
  AND NOT EXISTS (
    SELECT 1
    FROM regexp_split_to_table(export_products, ', ') AS e
    INTERSECT
    SELECT 1
    FROM regexp_split_to_table(import_products, ', ') AS i
  );

 
 
/* -----------------------------------------------------------------------------
   FILE:    5_advanced_features.sql
   PURPOSE: Add normalization and consistency constraints to currency, gdp, and inflation tables
   SCHEMA:  student32 (Economy Project)
   AUTHOR:  Njomza Bytyqi (student32 / 330021)
   NOTES:   Implements CHECK, FK, and UNIQUE constraints and cleans up duplicates.
----------------------------------------------------------------------------- */

-- ============================================================================
-- SECTION 1: CHECK CONSTRAINTS FOR DATA VALIDATION
-- ============================================================================

-- 1.1 Ensure that every exchange_rate in currency is greater than zero
ALTER TABLE student32.currency
  ADD CONSTRAINT currency_exchange_rate_positive
  CHECK (exchange_rate > 0);

-- 1.2 Ensure that no GDP amount is negative
ALTER TABLE student32.gdp
  ADD CONSTRAINT gdp_amount_positive
  CHECK (amount >= 0);

-- 1.3 Ensure that inflation rate is always provided (NOT NULL)
ALTER TABLE student32.inflation
  ALTER COLUMN rate SET NOT NULL;


-- ============================================================================
-- SECTION 2: FOREIGN KEY CONSTRAINTS
-- ============================================================================

-- 2.1 Link GDP records to their currency
ALTER TABLE student32.gdp
  ADD CONSTRAINT gdp_currency_fk
  FOREIGN KEY (currency_code)
    REFERENCES student32.currency(code)
    ON UPDATE CASCADE
    ON DELETE RESTRICT;


-- ============================================================================
-- SECTION 3: REMOVE DUPLICATES & ADD UNIQUE CONSTRAINTS
-- ============================================================================

-- 3.1 Remove duplicate GDP entries, keeping the lowest id for each (year, country, currency)
DELETE FROM student32.gdp AS g
USING (
  SELECT
    MIN(id)            AS id_to_keep,
    year,
    country_code,
    currency_code
  FROM student32.gdp
  GROUP BY year, country_code, currency_code
  HAVING COUNT(*) > 1
) AS dup
WHERE g.year          = dup.year
  AND g.country_code  = dup.country_code
  AND g.currency_code = dup.currency_code
  AND g.id            <> dup.id_to_keep;

-- 3.2 Enforce uniqueness on (year, country_code, currency_code) in GDP
ALTER TABLE student32.gdp
  ADD CONSTRAINT gdp_unique_year_country_currency
  UNIQUE (year, country_code, currency_code);

-- 3.3 Remove duplicate inflation entries, keeping the lowest id for each (year, country)
DELETE FROM student32.inflation AS i
USING (
  SELECT
    MIN(id)           AS id_to_keep,
    year,
    country_code
  FROM student32.inflation
  GROUP BY year, country_code
  HAVING COUNT(*) > 1
) AS dup
WHERE i.year         = dup.year
  AND i.country_code = dup.country_code
  AND i.id           <> dup.id_to_keep;

-- 3.4 Enforce uniqueness on (year, country_code) in Inflation
ALTER TABLE student32.inflation
  ADD CONSTRAINT inflation_unique_year_country
  UNIQUE (year, country_code);


-- ============================================================================
-- SECTION 4: NORMALIZATION NOTES
-- ============================================================================

-- At this point, all tables comply with:
--   • First Normal Form (1NF): All attributes are atomic.
--   • Second Normal Form (2NF): No partial dependency on a subset of a composite key.
--   • Third Normal Form (3NF): No transitive dependencies; non-key attributes depend only on the primary key.

