-- Active: 1750773846946@@141.47.5.117@5432@mondial
/*
  -----------------------------------------------------------------------
  -- Datei: 01_create_tables.sql
  -- Zweck: Tabellen zum Thema Arbeitsmarkt erstellen
  -- Tabellen:
  --   - unemployment     (Arbeitslosenquote)
  --   - average_salary   (Durchschnittslohn)
  --   - minimum_wage     (Mindestlohn)
  -- Enthält country_code (FK) und country_name (Text)
  -----------------------------------------------------------------------
*/

-- Tabelle: unemployment
CREATE TABLE unemployment (
  unemployment_id SERIAL PRIMARY KEY,
  country_code CHAR(2) NOT NULL REFERENCES country(code) ON DELETE CASCADE,
  country_name VARCHAR(100) NOT NULL,
  year SMALLINT NOT NULL,
  unemployment_rate NUMERIC(5,2)
);

-- Tabelle: average_salary
CREATE TABLE average_salary (
  average_salary_id SERIAL PRIMARY KEY,
  country_code CHAR(2) NOT NULL REFERENCES country(code) ON DELETE CASCADE,
  country_name VARCHAR(100) NOT NULL,
  year SMALLINT NOT NULL,
  amount NUMERIC(12,2) NOT NULL,
  currency_name VARCHAR(50) NOT NULL
);

-- Tabelle: minimum_wage
CREATE TABLE minimum_wage (
  minimum_wage_id SERIAL PRIMARY KEY,
  country_code CHAR(2) NOT NULL REFERENCES country(code) ON DELETE CASCADE,
  country_name VARCHAR(100) NOT NULL,
  year SMALLINT NOT NULL,
  amount NUMERIC(12,2),
  currency_name VARCHAR(50) NOT NULL
);
