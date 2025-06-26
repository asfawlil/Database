-- Mondial-Erweiterung: population_extended & lake_extended
-- Autorin: student38 | Jahr: 2023 | Modul: BIS2161 / BIS3081

-- Erweiterung 1: Bevölkerungstabelle mit ökonomischen Zusatzdaten
DROP TABLE IF EXISTS student38.population_extended CASCADE;

CREATE TABLE student38.population_extended AS
SELECT *, 2023 AS year FROM public.population;

ALTER TABLE student38.population_extended
ADD COLUMN population_density NUMERIC,
ADD COLUMN urban_percent NUMERIC,
ADD COLUMN fertility_rate NUMERIC,
ADD COLUMN migration_balance NUMERIC,
ADD COLUMN life_expectancy NUMERIC;

ALTER TABLE student38.population_extended
ADD PRIMARY KEY (country, year);

-- Beispielwerte für Deutschland & Frankreich
UPDATE student38.population_extended
SET 
  population_density = 233.1,
  urban_percent = 77.5,
  fertility_rate = 1.53,
  migration_balance = 250000,
  life_expectancy = 81.1
WHERE country = 'D' AND year = 2023;

UPDATE student38.population_extended
SET 
  population_density = 104.2,
  urban_percent = 80.1,
  fertility_rate = 1.41,
  migration_balance = 30000,
  life_expectancy = 82.7
WHERE country = 'F' AND year = 2023;

-- Zufallsdaten für alle übrigen Länder
UPDATE student38.population_extended
SET 
  population_density = ROUND((RANDOM() * 200 + 30)::numeric, 1),
  urban_percent = ROUND((RANDOM() * 50 + 50)::numeric, 1),
  fertility_rate = ROUND((RANDOM() * 1.5 + 1.0)::numeric, 2),
  migration_balance = ROUND((RANDOM() * 500000 - 250000)::numeric),
  life_expectancy = ROUND((RANDOM() * 15 + 65)::numeric, 1)
WHERE country NOT IN ('D', 'F');

-- Erweiterung 2: Seen mit Tourismus- und Umweltdaten
DROP TABLE IF EXISTS student38.lake_extended CASCADE;

CREATE TABLE student38.lake_extended AS
SELECT * FROM public.lake;

ALTER TABLE student38.lake_extended
ADD COLUMN tourist_rating INT CHECK (tourist_rating BETWEEN 1 AND 10),
ADD COLUMN protected_area BOOLEAN,
ADD COLUMN avg_depth NUMERIC,
ADD COLUMN water_quality_grade TEXT,
ADD COLUMN endangered_species_count INT,
ADD COLUMN annual_visitors_millions NUMERIC;

ALTER TABLE student38.lake_extended
ADD PRIMARY KEY (name, area);

-- Beispielhafte manuelle Werte
UPDATE student38.lake_extended
SET 
  tourist_rating = 9,
  protected_area = TRUE,
  avg_depth = 90,
  water_quality_grade = 'A',
  endangered_species_count = 12,
  annual_visitors_millions = 2.5,
  depth = 254,
  height = 100
WHERE name = 'Bodensee';

UPDATE student38.lake_extended
SET 
  tourist_rating = 7,
  protected_area = FALSE,
  avg_depth = 48,
  water_quality_grade = 'B',
  endangered_species_count = 5,
  annual_visitors_millions = 1.3,
  depth = 310,
  height = 120
WHERE name = 'Lake Geneva';

-- Automatisch generierte Daten für alle restlichen Seen
UPDATE student38.lake_extended
SET 
  tourist_rating = FLOOR(RANDOM() * 6 + 5)::int,
  protected_area = CASE WHEN RANDOM() < 0.4 THEN TRUE ELSE FALSE END,
  avg_depth = ROUND((RANDOM() * 300 + 20)::numeric, 1),
  water_quality_grade = CASE 
    WHEN RANDOM() < 0.6 THEN 'A' 
    WHEN RANDOM() < 0.85 THEN 'B' 
    ELSE 'C' 
  END,
  endangered_species_count = ROUND((RANDOM() * 15)::numeric)::int,
  annual_visitors_millions = ROUND((RANDOM() * 5 + 0.5)::numeric, 2),
  depth = COALESCE(depth, ROUND((RANDOM() * 300 + 10)::numeric, 1)),
  height = COALESCE(height, ROUND((RANDOM() * 400 + 50)::numeric, 1))
WHERE 
  tourist_rating IS NULL OR
  protected_area IS NULL OR
  avg_depth IS NULL OR
  water_quality_grade IS NULL OR
  endangered_species_count IS NULL OR
  annual_visitors_millions IS NULL OR
  depth IS NULL OR
  height IS NULL;

-- Kontrolle
SELECT * FROM student38.population_extended ORDER BY country;
SELECT * FROM student38.lake_extended ORDER BY name;
