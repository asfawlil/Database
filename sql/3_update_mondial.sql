/* -----------------------------------------------------------------------------
Wirtschaftliche Erweiterung für student32-Projekt
Erweiterte Tabellen für Länder, Städte, BIP & Inflation
@author: Njomza Bytyqi
----------------------------------------------------------------------------- */

-- ========== ERWEITERUNG 1: COUNTRY → Wirtschaftliche Zusatzdaten ==========

-- 1.1 Erweiterte Länder-Tabelle mit Wirtschaftsdaten
CREATE TABLE student32.country_economy AS
SELECT *
FROM public.country;

-- Primary Key setzen
ALTER TABLE student32.country_economy ADD PRIMARY KEY (code);

-- Zusätzliche wirtschaftliche Attribute
ALTER TABLE student32.country_economy
ADD COLUMN gdp_per_capita NUMERIC,
ADD COLUMN inflation_target NUMERIC,
ADD COLUMN central_bank_name TEXT,
ADD COLUMN eu_member BOOLEAN DEFAULT FALSE,
ADD COLUMN economic_zone TEXT,
ADD COLUMN sovereign_debt_percent NUMERIC, -- Staatsschulden in % des BIP
ADD COLUMN economic_classification TEXT;   -- z.B. "High Income", "Emerging Market"

-- 1.2 Verknüpfungstabelle: Land ↔ Wirtschaftsbranchen
CREATE TABLE student32.country_economic_sectors (
    country_code CHAR(3) NOT NULL REFERENCES public.country(code) ON DELETE CASCADE,
    sector_name TEXT NOT NULL,
    gdp_share_percent NUMERIC CHECK (gdp_share_percent >= 0 AND gdp_share_percent <= 100),
    employment_percent NUMERIC,
    export_value NUMERIC,
    PRIMARY KEY (country_code, sector_name)
);

-- ========== ERWEITERUNG 2: CITY → Wirtschaftszentren ==========

-- 2.1 Erweiterte Städte-Tabelle (robust mit ROW_NUMBER)
CREATE TABLE student32.city_economic_data AS
SELECT DISTINCT ON (name, country) *
FROM public.city
ORDER BY name, country;

-- 1. Bestehenden Primary Key entfernen 
ALTER TABLE student32.city_economic_data
DROP CONSTRAINT IF EXISTS city_economic_data_pkey;

-- 2. Spalte 'city_id' sicher entfernen, falls schon vorhanden
ALTER TABLE student32.city_economic_data
DROP COLUMN IF EXISTS city_id;

-- 3. Neue ID-Spalte hinzufügen 
ALTER TABLE student32.city_economic_data
ADD COLUMN city_id SERIAL PRIMARY KEY;

-- Wirtschaftsdaten für Städte
ALTER TABLE student32.city_economic_data
ADD COLUMN is_financial_hub BOOLEAN DEFAULT FALSE,
ADD COLUMN stock_exchange_present BOOLEAN DEFAULT FALSE,
ADD COLUMN gdp_city NUMERIC,
ADD COLUMN unemployment_rate NUMERIC,
ADD COLUMN major_industries TEXT,
ADD COLUMN annual_conferences INT,
ADD COLUMN international_organizations INT;

-- 2.2 Verknüpfungstabelle: Stadt ↔ BIP-Quellen
CREATE TABLE student32.city_gdp_sources (
    city_id INTEGER NOT NULL,
    country_code CHAR(3) NOT NULL,
    source_name TEXT NOT NULL,
    source_type TEXT CHECK (source_type IN ('Government', 'International', 'Private')),
    contribution_percent NUMERIC,
    year INT,
    FOREIGN KEY (city_id) REFERENCES student32.city_economic_data (city_id) ON DELETE CASCADE,
    PRIMARY KEY (city_id, country_code, source_name, year)
);

-- ========== Beispielhafte DATEN ==========

-- 3.1 Länder-Erweiterung
UPDATE student32.country_economy
SET
    gdp_per_capita = 48000,
    inflation_target = 2.0,
    central_bank_name = 'Deutsche Bundesbank',
    eu_member = TRUE,
    economic_zone = 'Eurozone',
    sovereign_debt_percent = 66.5,
    economic_classification = 'High Income'
WHERE code = 'DEU';

-- 3.2 Branchenanteile Deutschland
INSERT INTO student32.country_economic_sectors (
    country_code, sector_name, gdp_share_percent, employment_percent, export_value
) VALUES
    ('AL', 'Industry', 30.5, 25.1, 800000000000),
    ('GR', 'Services', 68.0, 72.3, 100000000000),
    ('CY', 'Agriculture', 1.5, 2.6, 20000000000);

-- 3.3 Städte-Erweiterung
UPDATE student32.city_economic_data
SET
    is_financial_hub = TRUE,
    stock_exchange_present = TRUE,
    gdp_city = 740000000000,
    unemployment_rate = 5.2,
    major_industries = 'Finance, Consulting, IT',
    annual_conferences = 120,
    international_organizations = 15
WHERE name = 'Frankfurt am Main' AND country = 'DEU';

-- 3.4 Stadt-BIP-Quellen
INSERT INTO student32.city_gdp_sources (
    city_id, country_code, source_name, source_type, contribution_percent, year
) VALUES
    (1, 'DEU', 'Statistisches Bundesamt', 'Government', 60.0, 2023),
    (1, 'DEU', 'European Central Bank', 'International', 40.0, 2023);