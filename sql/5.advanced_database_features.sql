-- ---------------------------------------------------------------
-- Advanced SQL Features: Views, Triggers & Stored Procedures
-- Author: Liliana Asfaw (student38)
-- ---------------------------------------------------------------

-- View: Overview of all labor market data for 2023
CREATE OR REPLACE VIEW student38.labor_market_summary_2023 AS
SELECT
  u.country_name,
  u.unemployment_rate,
  a.amount AS avg_salary,
  a.currency_name AS avg_salary_currency,
  m.amount AS min_wage,
  m.currency_name AS min_wage_currency
FROM student38.unemployment u
JOIN student38.average_salary a ON u.country_code = a.country_code AND u.year = a.year
JOIN student38.minimum_wage m ON u.country_code = m.country_code AND u.year = m.year
WHERE u.year = 2023;

-- Trigger Function: Minimum wage must not be < 1000 EUR (if set)
CREATE OR REPLACE FUNCTION student38.check_minimum_wage()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.amount IS NOT NULL AND NEW.amount < 1000 THEN
    RAISE EXCEPTION 'Minimum wage must not be below 1000 EUR: %', NEW.amount;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger Function: Average salary must be positive
CREATE OR REPLACE FUNCTION student38.check_average_salary()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.amount <= 0 THEN
    RAISE EXCEPTION 'Average salary must be positive: %', NEW.amount;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger Function: Unemployment rate must be between 0 and 100
CREATE OR REPLACE FUNCTION student38.check_unemployment_rate()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.unemployment_rate < 0 OR NEW.unemployment_rate > 100 THEN
    RAISE EXCEPTION 'Unemployment rate must be between 0 and 100: %', NEW.unemployment_rate;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger Registration
DROP TRIGGER IF EXISTS trg_check_min_wage ON student38.minimum_wage;
CREATE TRIGGER trg_check_min_wage
BEFORE INSERT OR UPDATE ON student38.minimum_wage
FOR EACH ROW
EXECUTE FUNCTION student38.check_minimum_wage();

DROP TRIGGER IF EXISTS trg_check_avg_salary ON student38.average_salary;
CREATE TRIGGER trg_check_avg_salary
BEFORE INSERT OR UPDATE ON student38.average_salary
FOR EACH ROW
EXECUTE FUNCTION student38.check_average_salary();

DROP TRIGGER IF EXISTS trg_check_unemployment ON student38.unemployment;
CREATE TRIGGER trg_check_unemployment
BEFORE INSERT OR UPDATE ON student38.unemployment
FOR EACH ROW
EXECUTE FUNCTION student38.check_unemployment_rate();

-- Stored Procedure: Insert or update average salary
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
    SELECT 1 FROM student38.average_salary WHERE country_code = p_country_code AND year = p_year
  ) THEN
    UPDATE student38.average_salary
    SET amount = p_amount, currency_name = p_currency
    WHERE country_code = p_country_code AND year = p_year;
  ELSE
    INSERT INTO student38.average_salary (country_code, country_name, year, amount, currency_name)
    VALUES (p_country_code, p_country_name, p_year, p_amount, p_currency);
  END IF;
END;
$$;

-- Stored Procedure: Insert or update minimum wage
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
    SELECT 1 FROM student38.minimum_wage WHERE country_code = p_country_code AND year = p_year
  ) THEN
    UPDATE student38.minimum_wage
    SET amount = p_amount, currency_name = p_currency
    WHERE country_code = p_country_code AND year = p_year;
  ELSE
    INSERT INTO student38.minimum_wage (country_code, country_name, year, amount, currency_name)
    VALUES (p_country_code, p_country_name, p_year, p_amount, p_currency);
  END IF;
END;
$$;

-- Stored Procedure: Insert or update unemployment rate
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
    SELECT 1 FROM student38.unemployment WHERE country_code = p_country_code AND year = p_year
  ) THEN
    UPDATE student38.unemployment
    SET unemployment_rate = p_unemployment_rate
    WHERE country_code = p_country_code AND year = p_year;
  ELSE
    INSERT INTO student38.unemployment (country_code, country_name, year, unemployment_rate)
    VALUES (p_country_code, p_country_name, p_year, p_unemployment_rate);
  END IF;
END;
$$;
