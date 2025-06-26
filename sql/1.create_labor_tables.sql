-- Active: 1750679793034@@141.47.5.117@5432@mondial
-- Arbeitsmarktdaten – Tabellenanlage für die Mondial-Erweiterung
-- Thema: Ökonomische Indikatoren (Arbeitslosenquote, Durchschnittslohn, Mindestlohn)
-- Autorin: student38 ; Liliana Asfaw 

-- Tabelle: unemployment
-- Speichert jährliche Arbeitslosenquoten pro Land (in Prozent)
CREATE TABLE unemployment (
  unemployment_id SERIAL PRIMARY KEY,
  country_code CHAR(2) NOT NULL REFERENCES country(code) ON DELETE CASCADE,
  country_name VARCHAR(100) NOT NULL,
  year SMALLINT NOT NULL,
  unemployment_rate NUMERIC(5,2)  -- z. B. 7.50 = 7,5 %
);

-- Tabelle: average_salary
-- Durchschnittliches Jahresgehalt pro Land und Jahr
CREATE TABLE average_salary (
  average_salary_id SERIAL PRIMARY KEY,
  country_code CHAR(2) NOT NULL REFERENCES country(code) ON DELETE CASCADE,
  country_name VARCHAR(100) NOT NULL,
  year SMALLINT NOT NULL,
  amount NUMERIC(12,2) NOT NULL,      -- z. B. 38500.00
  currency_name VARCHAR(50) NOT NULL  -- Währung (z. B. EUR, USD)
);

-- Tabelle: minimum_wage
-- Gesetzlich festgelegter Mindestlohn pro Jahr (falls vorhanden)
CREATE TABLE minimum_wage (
  minimum_wage_id SERIAL PRIMARY KEY,
  country_code CHAR(2) NOT NULL REFERENCES country(code) ON DELETE CASCADE,
  country_name VARCHAR(100) NOT NULL,
  year SMALLINT NOT NULL,
  amount NUMERIC(12,2),               -- NULL erlaubt, wenn kein Mindestlohn existiert
  currency_name VARCHAR(50) NOT NULL
);
