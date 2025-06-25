/*
  -----------------------------------------------------------------------
  -- Datei: 05_advanced_features.sql
  -- Zweck: Erweiterte SQL-Features für Arbeitsmarktdaten
  -- Autor: student38
  -----------------------------------------------------------------------
*/

-- ===============================
--  VIEW: Übersichtstabelle mit Löhnen & Arbeitslosigkeit
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
--  TRIGGER: Mindestlohn darf nicht unter 1000 EUR fallen
-- ===============================

-- Trigger-Funktion
CREATE OR REPLACE FUNCTION student38.check_minimum_wage()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.amount IS NOT NULL AND NEW.amount < 1000 THEN
    RAISE EXCEPTION 'Mindestlohn darf nicht unter 1000 EUR liegen: %', NEW.amount;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger an Tabelle anhängen
DROP TRIGGER IF EXISTS trg_check_min_wage ON student38.minimum_wage;

CREATE TRIGGER trg_check_min_wage
BEFORE INSERT OR UPDATE ON student38.minimum_wage
FOR EACH ROW
EXECUTE FUNCTION student38.check_minimum_wage();


-- ===============================
--  STORED PROCEDURE: Durchschnittslohn einfügen oder updaten
-- ===============================

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
    WHERE country_code = p_country_code AND year = p_year
  ) THEN
    UPDATE student38.average_salary
    SET amount = p_amount,
        currency_name = p_currency
    WHERE country_code = p_country_code AND year = p_year;
  ELSE
    INSERT INTO student38.average_salary (country_code, country_name, year, amount, currency_name)
    VALUES (p_country_code, p_country_name, p_year, p_amount, p_currency);
  END IF;
END;
$$;

-- Beispielaufruf:
-- CALL student38.upsert_average_salary('DE', 'Germany', 2023, 45500, 'EUR');


-- ===============================
--  NEUE CONSTRAINTS – Datenkonsistenz
-- ===============================

-- Durchschnittslohn > 0
ALTER TABLE student38.average_salary
ADD CONSTRAINT avg_salary_positive CHECK (amount > 0);

-- Arbeitslosenquote zwischen 0 und 100
ALTER TABLE student38.unemployment
ADD CONSTRAINT unemployment_rate_valid CHECK (unemployment_rate >= 0 AND unemployment_rate <= 100);

-- Mindestlohn >= 0 oder NULL erlaubt
ALTER TABLE student38.minimum_wage
ADD CONSTRAINT min_wage_non_negative CHECK (amount IS NULL OR amount >= 0);


-- ===============================
--  EINDEUTIGKEIT – keine doppelten Werte
-- ===============================

ALTER TABLE student38.unemployment
ADD CONSTRAINT unemployment_unique_country_year UNIQUE (country_code, year);

ALTER TABLE student38.average_salary
ADD CONSTRAINT avg_salary_unique_country_year UNIQUE (country_code, year);

ALTER TABLE student38.minimum_wage
ADD CONSTRAINT min_wage_unique_country_year UNIQUE (country_code, year);

-- ===============================
--  OPTIONALER TRIGGER: Mindestlohn darf nicht unter 1000 EUR fallen
-- ===============================

-- 1. Trigger-Funktion definieren
CREATE OR REPLACE FUNCTION student38.check_minimum_wage()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.amount IS NOT NULL AND NEW.amount < 1000 THEN
    RAISE EXCEPTION 'Mindestlohn darf nicht unter 1000 EUR liegen: %', NEW.amount;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ===============================
--  TRIGGER
-- ===============================
DROP TRIGGER IF EXISTS trg_check_min_wage ON student38.minimum_wage;

CREATE TRIGGER trg_check_min_wage
BEFORE INSERT OR UPDATE ON student38.minimum_wage
FOR EACH ROW
EXECUTE FUNCTION student38.check_minimum_wage();
