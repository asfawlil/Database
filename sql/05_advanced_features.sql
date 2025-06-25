/*
  -----------------------------------------------------------------------
  -- Datei: 05_advanced_features.sql
  -- Zweck: Erweiterte SQL-Features für Arbeitsmarktdaten
  -- Autor: student38
  -----------------------------------------------------------------------
*/

-- ===============================
--  VIEW: Übersicht zu Arbeitsmarktdaten 2023
-- ===============================

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

-- ===============================
--  TRIGGER-FUNKTIONEN
-- ===============================

-- Mindestlohn >= 1000 EUR (falls vorhanden)
CREATE OR REPLACE FUNCTION student38.check_minimum_wage()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.amount IS NOT NULL AND NEW.amount < 1000 THEN
    RAISE EXCEPTION 'Mindestlohn darf nicht unter 1000 EUR liegen: %', NEW.amount;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Durchschnittslohn > 0
CREATE OR REPLACE FUNCTION student38.check_average_salary()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.amount <= 0 THEN
    RAISE EXCEPTION 'Durchschnittslohn muss positiv sein: %', NEW.amount;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Arbeitslosenquote zwischen 0 und 100
CREATE OR REPLACE FUNCTION student38.check_unemployment_rate()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.unemployment_rate < 0 OR NEW.unemployment_rate > 100 THEN
    RAISE EXCEPTION 'Arbeitslosenquote muss zwischen 0 und 100 liegen: %', NEW.unemployment_rate;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ===============================
--  TRIGGER REGISTRIEREN
-- ===============================

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

-- ===============================
--  STORED PROCEDURES
-- ===============================

-- Durchschnittslohn einfügen oder updaten
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

-- Mindestlohn einfügen oder updaten
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

-- Arbeitslosenquote einfügen oder updaten
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

-- ===============================
--  Constraints
-- ===============================

-- Constraint: Mindestlohn darf nicht negativ sein (NULL ist erlaubt)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.table_constraints 
    WHERE constraint_name = 'min_wage_non_negative'
      AND table_name = 'minimum_wage'
      AND table_schema = 'student38'
  ) THEN
    ALTER TABLE student38.minimum_wage
    ADD CONSTRAINT min_wage_non_negative CHECK (amount IS NULL OR amount >= 0);
  END IF;
END $$;


-- Constraint: Durchschnittslohn muss > 0 sein
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.table_constraints 
    WHERE constraint_name = 'avg_salary_positive'
      AND table_name = 'average_salary'
      AND table_schema = 'student38'
  ) THEN
    ALTER TABLE student38.average_salary
    ADD CONSTRAINT avg_salary_positive CHECK (amount > 0);
  END IF;
END $$;


-- Constraint: Arbeitslosenquote muss zwischen 0 und 100 liegen
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.table_constraints 
    WHERE constraint_name = 'unemployment_rate_valid'
      AND table_name = 'unemployment'
      AND table_schema = 'student38'
  ) THEN
    ALTER TABLE student38.unemployment
    ADD CONSTRAINT unemployment_rate_valid CHECK (unemployment_rate >= 0 AND unemployment_rate <= 100);
  END IF;
END $$;


-- ===============================
-- 🔹 EINDEUTIGKEIT & DOPPELTE ENTRIES BEREINIGEN
-- ===============================

-- Unemployment
DELETE FROM student38.unemployment u
USING (
  SELECT MIN(unemployment_id) AS keep_id, country_code, year
  FROM student38.unemployment
  GROUP BY country_code, year
  HAVING COUNT(*) > 1
) d
WHERE u.country_code = d.country_code AND u.year = d.year AND u.unemployment_id <> d.keep_id;

ALTER TABLE student38.unemployment
ADD CONSTRAINT IF NOT EXISTS unemployment_unique_country_year UNIQUE (country_code, year);

-- Average Salary
DELETE FROM student38.average_salary a
USING (
  SELECT MIN(average_salary_id) AS keep_id, country_code, year
  FROM student38.average_salary
  GROUP BY country_code, year
  HAVING COUNT(*) > 1
) d
WHERE a.country_code = d.country_code AND a.year = d.year AND a.average_salary_id <> d.keep_id;

ALTER TABLE student38.average_salary
ADD CONSTRAINT IF NOT EXISTS avg_salary_unique_country_year UNIQUE (country_code, year);

-- Minimum Wage
DELETE FROM student38.minimum_wage m
USING (
  SELECT MIN(minimum_wage_id) AS keep_id, country_code, year
  FROM student38.minimum_wage
  GROUP BY country_code, year
  HAVING COUNT(*) > 1
) d
WHERE m.country_code = d.country_code AND m.year = d.year AND m.minimum_wage_id <> d.keep_id;

ALTER TABLE student38.minimum_wage
ADD CONSTRAINT IF NOT EXISTS min_wage_unique_country_year UNIQUE (country_code, year);
