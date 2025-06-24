-- Active: 1750679793034@@141.47.5.117@5432@mondial
-- Active: 1750679793034@@141.47.5.117@5432@mondial-- Active: 1750679793034@@141.47.5.117@5432@mondial
/*
  -----------------------------------------------------------------------
  -- Datei: 03_update_mondial_relations.sql
  -- Zweck: Erweiterung & Update von 2 Mondial-Relationen: population & lake
  -- Autor: student38
  -----------------------------------------------------------------------
*/

-- =====================================================================
-- 🔹 ERWEITERUNG 1: population_extended → Zusatzinfos zur Bevölkerung
-- =====================================================================

-- 1.1 Kopie von public.population in dein Schema
CREATE TABLE student38.population_extended AS
SELECT * FROM public.population;

-- 1.2.1 year Spalte hinzufügen
ALTER TABLE student38.population_extended
ADD COLUMN year INT;


-- 1.2.2 Primärschlüssel setzen
ALTER TABLE student38.population_extended
ADD PRIMARY KEY (country, year);

-- 1.3 Zusätzliche Spalten einfügen
ALTER TABLE student38.population_extended
ADD COLUMN population_density NUMERIC,          -- Einwohner/km²
ADD COLUMN urban_percent NUMERIC,               -- Urbanisierungsgrad
ADD COLUMN fertility_rate NUMERIC,              -- Kinder/Frau
ADD COLUMN migration_balance NUMERIC,           -- Nettozuwanderung
ADD COLUMN life_expectancy NUMERIC;             -- Lebenserwartung

-- 1.4 Beispielhafte Updates
UPDATE student38.population_extended
SET 
  population_density = 233.1,
  urban_percent = 77.5,
  fertility_rate = 1.53,
  migration_balance = 250000,
  life_expectancy = 81.1
WHERE country = 'D' AND year = 2020;

UPDATE student38.population_extended
SET 
  population_density = 104.2,
  urban_percent = 80.1,
  fertility_rate = 1.41,
  migration_balance = 30000,
  life_expectancy = 82.7
WHERE country = 'F' AND year = 2020;

-- =====================================================================
-- 🔹 ERWEITERUNG 2: lake_extended → Zusatzinfos zu Seen
-- =====================================================================

-- 2.1 Kopie von public.lake in dein Schema
CREATE TABLE student38.lake_extended AS
SELECT * FROM public.lake;

-- 2.2 Primärschlüssel setzen
ALTER TABLE student38.lake_extended
ADD PRIMARY KEY (name);

-- 2.3 Zusätzliche Felder ergänzen
ALTER TABLE student38.lake_extended
ADD COLUMN tourist_rating INT CHECK (tourist_rating BETWEEN 1 AND 10),
ADD COLUMN protected_area BOOLEAN,
ADD COLUMN avg_depth NUMERIC,                    -- in Metern
ADD COLUMN water_quality_grade TEXT,             -- A, B, C ...
ADD COLUMN endangered_species_count INT,         -- Anzahl seltener Arten
ADD COLUMN annual_visitors_millions NUMERIC;     -- Besucher in Mio.

-- 2.4 Beispielhafte Updates
UPDATE student38.lake_extended
SET 
  tourist_rating = 9,
  protected_area = TRUE,
  avg_depth = 90,
  water_quality_grade = 'A',
  endangered_species_count = 12,
  annual_visitors_millions = 2.5
WHERE name = 'Bodensee';

UPDATE student38.lake_extended
SET 
  tourist_rating = 7,
  protected_area = FALSE,
  avg_depth = 48,
  water_quality_grade = 'B',
  endangered_species_count = 5,
  annual_visitors_millions = 1.3
WHERE name = 'Lake Geneva';

-- =====================================================================
-- 🔎 Kontrolle (optional)
-- =====================================================================
SELECT * FROM student38.population_extended WHERE country IN ('D', 'F') ORDER BY year DESC;
SELECT * FROM student38.lake_extended WHERE name IN ('Bodensee', 'Lake Geneva');
