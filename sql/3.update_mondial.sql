---------------------------------------------------------------
-- Mondial-Erweiterung: Bevölkerung & Seen (Population & Lakes)
-- Autorin: Liliana Asfaw (student38)
---------------------------------------------------------------

-- ERWEITERUNG 1: Bevölkerung mit Zusatzdaten 

DROP TABLE IF EXISTS student38.population_extended CASCADE;

CREATE TABLE student38.population_extended AS
SELECT 
  c.code AS country,             -- z. B. 'D'
  c.name AS country_name,        -- z. B. 'Germany'
  c.population AS population,    -- aktuelle Bevölkerung
  2023 AS year                   -- festes Jahr
FROM public.country c;

ALTER TABLE student38.population_extended
ADD COLUMN population_density NUMERIC,
ADD COLUMN urban_percent NUMERIC,
ADD COLUMN fertility_rate NUMERIC,
ADD COLUMN migration_balance NUMERIC,
ADD COLUMN life_expectancy NUMERIC;

ALTER TABLE student38.population_extended
ADD PRIMARY KEY (country, year);

-- Zufallsdaten für alle Länder 
UPDATE student38.population_extended
SET 
  population_density = ROUND((RANDOM() * 200 + 30)::NUMERIC, 1),
  urban_percent = ROUND((RANDOM() * 50 + 50)::NUMERIC, 1),
  fertility_rate = ROUND((RANDOM() * 1.5 + 1.0)::NUMERIC, 2),
  migration_balance = ROUND((RANDOM() * 500000 - 250000)::NUMERIC),
  life_expectancy = ROUND((RANDOM() * 15 + 65)::NUMERIC, 1);


-- ERWEITERUNG 2: Seen mit Umwelt- & Tourismusdaten

DROP TABLE IF EXISTS student38.lake_extended CASCADE;

CREATE TABLE student38.lake_extended (
    lake_id SERIAL PRIMARY KEY,
    name TEXT,
    country_code TEXT,
    country_name TEXT,
    area NUMERIC,
    depth NUMERIC,
    height NUMERIC,
    year SMALLINT,
    tourist_rating INT CHECK (tourist_rating BETWEEN 1 AND 10),
    protected_area BOOLEAN,
    avg_depth NUMERIC,
    water_quality_grade TEXT,
    endangered_species_count INT,
    annual_visitors_millions NUMERIC,
    type TEXT
);

-- Seen mit Land aus Mondial verknüpfen
INSERT INTO student38.lake_extended (
    name, country_code, country_name, area, depth, height, year
)
SELECT 
    l.name,
    c.code AS country_code,
    c.name AS country_name,
    l.area,
    l.depth,
    l.height,
    2023 AS year
FROM public.lake l
JOIN public.located loc ON l.name = loc.lake
JOIN public.country c ON loc.country = c.code;

-- Zufallsdaten für alle Seen 
UPDATE student38.lake_extended
SET 
    tourist_rating = FLOOR(RANDOM() * 6 + 5)::INT,
    protected_area = CASE WHEN RANDOM() < 0.4 THEN TRUE ELSE FALSE END,
    avg_depth = ROUND((RANDOM() * 300 + 20)::NUMERIC, 1),
    water_quality_grade = CASE 
        WHEN RANDOM() < 0.6 THEN 'A' 
        WHEN RANDOM() < 0.85 THEN 'B' 
        ELSE 'C' 
    END,
    endangered_species_count = ROUND((RANDOM() * 15)::NUMERIC)::INT,
    annual_visitors_millions = ROUND((RANDOM() * 5 + 0.5)::NUMERIC, 2),
    type = CASE 
        WHEN name ILIKE '%reserv%' OR name ILIKE '%dam%' THEN 'reservoir'
        WHEN name ILIKE '%lake%' OR name ILIKE '%see%' THEN 'natural'
        ELSE CASE WHEN RANDOM() < 0.85 THEN 'natural' ELSE 'reservoir' END
    END,
    height = COALESCE(height, ROUND((RANDOM() * 800 + 100)::NUMERIC, 1));

-- ---------------------
-- Kontrolle

SELECT * FROM student38.population_extended ORDER BY country;
SELECT * FROM student38.lake_extended ORDER BY country_name, name;
