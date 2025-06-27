---------------------------------------------------------------
-- Mondial Extension: Population & Lakes
-- Author: Liliana Asfaw (student38)
---------------------------------------------------------------

-- Remove existing extended population table to prevent conflicts
DROP TABLE IF EXISTS student38.population_extended CASCADE;

-- Clone country table structure and add a fixed snapshot year
CREATE TABLE student38.population_extended AS
SELECT 
  c.code AS country,             -- ISO country code for FK consistency
  c.name AS country_name,        -- Human-readable country name
  c.population AS population,    -- Current total population
  2023 AS year                   -- Static reference year for temporal analysis
FROM public.country c;

-- Enrich with demographic metrics to support detailed analysis
ALTER TABLE student38.population_extended
  ADD COLUMN population_density NUMERIC,      -- Density in people/km²
  ADD COLUMN urban_percent NUMERIC,           -- Urbanization rate in percent
  ADD COLUMN fertility_rate NUMERIC,          -- Average children per woman
  ADD COLUMN migration_balance NUMERIC,       -- Net migration count
  ADD COLUMN life_expectancy NUMERIC;         -- Life expectancy at birth

-- Enforce uniqueness on country and year to maintain data integrity
ALTER TABLE student38.population_extended
  ADD PRIMARY KEY (country, year);

-- Populate demographic fields with realistic sample ranges
UPDATE student38.population_extended
SET 
  population_density   = ROUND((RANDOM() * 200 + 30)::NUMERIC, 1),   -- 30–230 people/km²
  urban_percent        = ROUND((RANDOM() * 50 + 50)::NUMERIC, 1),    -- 50–100%
  fertility_rate       = ROUND((RANDOM() * 1.5 + 1.0)::NUMERIC, 2),  -- 1.00–2.50 children/woman
  migration_balance    = ROUND((RANDOM() * 500000 - 250000)::NUMERIC),-- ±250k migrants
  life_expectancy      = ROUND((RANDOM() * 15 + 65)::NUMERIC, 1);    -- 65.0–80.0 years

-- Remove existing extended lake table to allow clean recreation
DROP TABLE IF EXISTS student38.lake_extended CASCADE;

-- Define lake extension with diverse columns for environmental and tourism data
CREATE TABLE student38.lake_extended (
    lake_id SERIAL PRIMARY KEY,                    -- Surrogate key for lake records
    name TEXT,                                     -- Lake name
    country_code TEXT,                             -- ISO code for country link
    country_name TEXT,                             -- Human-friendly country name
    area NUMERIC,                                  -- Surface area in km²
    depth NUMERIC,                                 -- Maximum depth in meters
    height NUMERIC,                                -- Elevation above sea level in meters
    year SMALLINT,                                 -- Data reference year
    tourist_rating INT CHECK (tourist_rating BETWEEN 1 AND 10),  -- 1–10 scale
    protected_area BOOLEAN,                        -- Protected status flag
    avg_depth NUMERIC,                             -- Average depth in meters
    water_quality_grade TEXT,                      -- Quality grade (A–C)
    endangered_species_count INT,                  -- Count of endangered species
    annual_visitors_millions NUMERIC,              -- Visitor numbers in millions
    type TEXT                                      -- Classification: natural or reservoir
);

-- Populate lake_extended by joining Mondial base tables for referential accuracy
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

-- Generate sample lake attributes with conditional logic and realistic ranges
UPDATE student38.lake_extended
SET 
    tourist_rating          = FLOOR(RANDOM() * 6 + 5)::INT,           -- Ratings 5–10
    protected_area          = (RANDOM() < 0.4),                      -- ~40% chance protected
    avg_depth               = ROUND((RANDOM() * 300 + 20)::NUMERIC, 1), -- 20–320 m
    water_quality_grade     = CASE 
                                WHEN RANDOM() < 0.6 THEN 'A' 
                                WHEN RANDOM() < 0.85 THEN 'B' 
                                ELSE 'C' 
                              END,                                   -- Grades by probability
    endangered_species_count= ROUND((RANDOM() * 15)::NUMERIC)::INT,  -- Up to 15 species
    annual_visitors_millions= ROUND((RANDOM() * 5 + 0.5)::NUMERIC, 2), -- 0.5–5.5 million
    type                    = CASE 
                                WHEN name ILIKE '%reserv%' OR name ILIKE '%dam%' THEN 'reservoir'
                                WHEN name ILIKE '%lake%' OR name ILIKE '%see%' THEN 'natural'
                                ELSE CASE WHEN RANDOM() < 0.85 THEN 'natural' ELSE 'reservoir' END
                              END,
    height                  = COALESCE(height, ROUND((RANDOM() * 800 + 100)::NUMERIC, 1)); -- Fill missing elevation

-- Queries for verification and inspection of the extended tables
SELECT * FROM student38.population_extended ORDER BY country;
SELECT * FROM student38.lake_extended ORDER BY country_name, name;
