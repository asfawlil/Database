-- ---------------------------------------------------------------
-- Advanced SQL Features: Views, Triggers & Stored Procedures
-- Author: Liliana Asfaw (student38/329850)
-- ---------------------------------------------------------------

-- View: Overview of all labor market data for 2023
-- Encapsulates joins for unemployment, salary, and minimum wage into a reusable object
CREATE OR REPLACE VIEW student38.labor_market_summary_2023 AS
SELECT
  u.country_name,                               -- Readable country identifier
  u.unemployment_rate,                          -- Unemployment rate percentage
  a.amount AS avg_salary,                       -- Average annual salary amount
  a.currency_name AS avg_salary_currency,       -- Currency code for salary
  m.amount AS min_wage,                         -- Statutory minimum wage amount
  m.currency_name AS min_wage_currency          -- Currency code for minimum wage
FROM student38.unemployment u
JOIN student38.average_salary a 
  ON u.country_code = a.country_code 
  AND u.year = a.year                            -- Aligns records by country and year
JOIN student38.minimum_wage m 
  ON u.country_code = m.country_code 
  AND u.year = m.year                            -- Ensures all three metrics match
WHERE u.year = 2023;                             -- Limits to the target analysis year

-- Trigger Function: Enforce a minimum threshold for minimum wage
-- Checks before insert or update to maintain business rule consistency
CREATE OR REPLACE FUNCTION student38.check_minimum_wage()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.amount IS NOT NULL AND NEW.amount < 1000 THEN  -- Validates realistic wage
    RAISE EXCEPTION 'Minimum wage must not be below 1000 EUR: %', NEW.amount;
  END IF;
  RETURN NEW;                                           -- Allows compliant rows
END;
$$ LANGUAGE plpgsql;

-- Trigger Function: Ensure average salary is positive
-- Prevents nonsensical or corrupt salary entries
CREATE OR REPLACE FUNCTION student38.check_average_salary()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.amount <= 0 THEN                              -- Disallows zero or negative values
    RAISE EXCEPTION 'Average salary must be positive: %', NEW.amount;
  END IF;
  RETURN NEW;                                          -- Permits only valid data
END;
$$ LANGUAGE plpgsql;

-- Trigger Function: Validate unemployment rate bounds
-- Guards against out-of-range percentage values
CREATE OR REPLACE FUNCTION student38.check_unemployment_rate()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.unemployment_rate < 0 OR NEW.unemployment_rate > 100 THEN
    RAISE EXCEPTION 'Unemployment rate must be between 0 and 100: %', NEW.unemployment_rate;
  END IF;
  RETURN NEW;                                          -- Ensures rate stays within logical bounds
END;
$$ LANGUAGE plpgsql;

-- Trigger Registration: Clear existing triggers to avoid duplicates
DROP TRIGGER IF EXISTS trg_check_min_wage ON student38.minimum_wage;
-- Attach minimum wage validation to the minimum_wage table
CREATE TRIGGER trg_check_min_wage
BEFORE INSERT OR UPDATE ON student38.minimum_wage
FOR EACH ROW
EXECUTE FUNCTION student38.check_minimum_wage();

DROP TRIGGER IF EXISTS trg_check_avg_salary ON student38.average_salary;
-- Attach average salary validation to the average_salary table
CREATE TRIGGER trg_check_avg_salary
BEFORE INSERT OR UPDATE ON student38.average_salary
FOR EACH ROW
EXECUTE FUNCTION student38.check_average_salary();

DROP TRIGGER IF EXISTS trg_check_unemployment ON student38.unemployment;
-- Attach unemployment rate validation to the unemployment table
CREATE TRIGGER trg_check_unemployment
BEFORE INSERT OR UPDATE ON student38.unemployment
FOR EACH ROW
EXECUTE FUNCTION student38.check_unemployment_rate();

-- Stored Procedure: Upsert logic for average salary
-- Combines insert and update logic for consistency and idempotence
CREATE OR REPLACE PROCEDURE student38.upsert_average_salary(
  p_country_code CHAR(2),
  p_country_name VARCHAR,
  p_year SMALLINT,
  p_amount NUMERIC,
  p_currency VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM student38.average_salary 
    WHERE country_code = p_country_code 
      AND year = p_year
  ) THEN
    UPDATE student38.average_salary
    SET amount = p_amount, currency_name = p_currency
    WHERE country_code = p_country_code 
      AND year = p_year;                          -- Updates existing record
  ELSE
    INSERT INTO student38.average_salary 
      (country_code, country_name, year, amount, currency_name)
    VALUES 
      (p_country_code, p_country_name, p_year, p_amount, p_currency);  -- Inserts new record
  END IF;
END;
$$;

-- Stored Procedure: Upsert logic for minimum wage
-- Maintains up-to-date wage data without duplicates
CREATE OR REPLACE PROCEDURE student38.upsert_minimum_wage(
  p_country_code CHAR(2),
  p_country_name VARCHAR,
  p_year SMALLINT,
  p_amount NUMERIC,
  p_currency VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM student38.minimum_wage 
    WHERE country_code = p_country_code 
      AND year = p_year
  ) THEN
    UPDATE student38.minimum_wage
    SET amount = p_amount, currency_name = p_currency
    WHERE country_code = p_country_code 
      AND year = p_year;                          -- Updates if exists
  ELSE
    INSERT INTO student38.minimum_wage 
      (country_code, country_name, year, amount, currency_name)
    VALUES 
      (p_country_code, p_country_name, p_year, p_amount, p_currency);  -- Inserts if new
  END IF;
END;
$$;

-- Stored Procedure: Upsert logic for unemployment rate
-- Centralizes insert/update behavior for consistency across data loads
CREATE OR REPLACE PROCEDURE student38.upsert_unemployment(
  p_country_code CHAR(2),
  p_country_name VARCHAR,
  p_year SMALLINT,
  p_unemployment_rate NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM student38.unemployment 
    WHERE country_code = p_country_code 
      AND year = p_year
  ) THEN
    UPDATE student38.unemployment
    SET unemployment_rate = p_unemployment_rate
    WHERE country_code = p_country_code 
      AND year = p_year;                          -- Updates existing entry
  ELSE
    INSERT INTO student38.unemployment 
      (country_code, country_name, year, unemployment_rate)
    VALUES 
      (p_country_code, p_country_name, p_year, p_unemployment_rate);  -- Inserts new entry
  END IF;
END;
$$;
