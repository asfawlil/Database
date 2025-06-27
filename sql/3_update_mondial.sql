/* -----------------------------------------------------------------------------
   FILE:    3_update_mondial_relations.sql
   PURPOSE: Extension & update of two Mondial relations:
            1) student32.province_economy_extended
            2) student32.city_economic_data_extended
   SCHEMA:  student32 (Economy indicators)
   AUTHOR:  Njomza Bytyqi (student32 / 330021)
   NOTES:   - All DDL and DML steps are idempotent (use IF EXISTS / IF NOT EXISTS)
            - Clear separation of DDL and DML sections
            - Consistent uppercase for SQL keywords
            - Semicolons at end of each statement
            - Wrap in a transaction for atomicity
----------------------------------------------------------------------------- */


-- ============================================================================
-- SECTION 1: PROVINCE EXTENSION
-- ============================================================================

-- 1.0 Drop old extended table if it exists
DROP TABLE IF EXISTS student32.province_economy_extended CASCADE;

-- 1.1 Copy base table and add reference year
CREATE TABLE IF NOT EXISTS student32.province_economy_extended AS
SELECT
  p.*,
  2023 AS reference_year
FROM
  public.province AS p;

-- 1.2 Add new economic indicator columns
ALTER TABLE student32.province_economy_extended
  ADD COLUMN IF NOT EXISTS province_gdp_per_capita    NUMERIC,  -- new: GDP per capita
  ADD COLUMN IF NOT EXISTS province_infaltion_rate    NUMERIC,  -- new: Inflation rate
  ADD COLUMN IF NOT EXISTS province_unemployment_rate NUMERIC,  -- new: Unemployment rate
  ADD COLUMN IF NOT EXISTS province_gdp               NUMERIC,  -- new: Estimated total GDP
  ADD COLUMN IF NOT EXISTS population_density         NUMERIC;  -- new: Population density

-- 1.3 Add primary key constraint
ALTER TABLE student32.province_economy_extended
  ADD CONSTRAINT pk_province_economy PRIMARY KEY (name, country, reference_year);

-- 1.4 Populate random placeholder values for 2023 provinces
UPDATE student32.province_economy_extended
SET
  province_gdp_per_capita    = ROUND((random() * 40000 + 5000)::numeric, 2),  -- between 5,000 and 45,000
  province_infaltion_rate    = ROUND((random() * 5)::numeric, 2),             -- between 0% and 5%
  province_unemployment_rate = ROUND((random() * 15)::numeric, 1),            -- between 0% and 15%
  province_gdp               = ROUND(
                                  COALESCE(province_gdp_per_capita, 0)
                                  * COALESCE(population, 0)
                                , 2),                                         -- GDP per capita × population
  population_density         = ROUND(population / NULLIF(area, 0), 2)        -- population ÷ area
WHERE
  reference_year = 2023;

-- ============================================================================
-- SECTION 2: CITY EXTENSION
-- ============================================================================

-- 2.0 Drop old extended table if it exists
DROP TABLE IF EXISTS student32.city_economic_data_extended CASCADE;

-- 2.1 Copy base table and add reference year
CREATE TABLE IF NOT EXISTS student32.city_economic_data_extended AS
SELECT
  ced.*,
  2023 AS reference_year
FROM
  student32.city_economic_data AS ced;

-- 2.2 Add new economic indicator columns
ALTER TABLE student32.city_economic_data_extended
  ADD COLUMN IF NOT EXISTS tourism_index            NUMERIC,  -- new: Tourism index (0–100)
  ADD COLUMN IF NOT EXISTS avg_income_per_capita    NUMERIC,  -- new: Average income per capita
  ADD COLUMN IF NOT EXISTS public_transport_quality NUMERIC;  -- new: Public transport quality (1–10)

-- 2.3 Add new geographic detail columns
ALTER TABLE student32.city_economic_data_extended
  ADD COLUMN IF NOT EXISTS latitude   NUMERIC,    -- new: Latitude
  ADD COLUMN IF NOT EXISTS longitude  NUMERIC,    -- new: Longitude
  ADD COLUMN IF NOT EXISTS elevation  NUMERIC;    -- new: Elevation above sea level (m)

-- 2.4 Populate geographic details via join on public.city
UPDATE student32.city_economic_data_extended AS cedx
SET
  latitude  = pc.latitude,
  longitude = pc.longitude,
  elevation = pc.elevation
FROM
  public.city AS pc
WHERE
  cedx.name        = pc.name
  AND cedx.country = pc.country
  AND cedx.reference_year = 2023;

-- 2.5 Add primary key constraint
ALTER TABLE student32.city_economic_data_extended
  ADD CONSTRAINT pk_city_economic PRIMARY KEY (city_id, reference_year);

-- 2.6–2.12 Populate random placeholder values for NULL columns
UPDATE student32.city_economic_data_extended
SET
  tourism_index            = COALESCE(tourism_index,
                                     ROUND((random() * 50 + 30)::numeric, 1)),  -- between 30 and 80
  public_transport_quality = COALESCE(public_transport_quality,
                                     ROUND((random() * 4 + 6)::numeric, 1)),   -- between 6 and 10
  avg_income_per_capita    = COALESCE(avg_income_per_capita,
                                     ROUND((random() * 50000 + 25000)::numeric, 0)), -- between 25k and 75k
  major_industries         = CASE FLOOR(random() * 5)::int
                                 WHEN 0 THEN 'Services, Retail, Manufacturing'
                                 WHEN 1 THEN 'Finance, Insurance, Real Estate'
                                 WHEN 2 THEN 'Tourism, Arts, Culture'
                                 WHEN 3 THEN 'Technology, Startups, Research'
                                 WHEN 4 THEN 'Logistics, Transport, Wholesale'
                               END,
  annual_conferences         = COALESCE(annual_conferences,
                                       (FLOOR(random() * 50 + 1))::int),  -- between 1 and 50
  international_organizations = COALESCE(international_organizations,
                                       (FLOOR(random() * 20))::int),      -- between 0 and 19
  unemployment_rate          = COALESCE(unemployment_rate,
                                       ROUND((random() * 11 + 3)::numeric, 1)), -- between 3% and 14%
  gdp_city                   = COALESCE(gdp_city,
                                       ROUND((random() * 9900000 + 100000)::numeric, 0)) -- between 100k and 10M
WHERE
  reference_year = 2023;

-- ============================================================================
-- SECTION 3: VALIDATION QUERIES
-- ============================================================================

-- 3.1 Validate province_economy_extended
SELECT
  country,
  name,
  reference_year,
  province_gdp_per_capita,
  province_infaltion_rate,
  province_unemployment_rate,
  province_gdp,
  population_density
FROM
  student32.province_economy_extended
ORDER BY
  country, name;

-- 3.2 Validate city_economic_data_extended
SELECT
  city_id,
  name,
  country,
  reference_year,
  population,
  latitude,
  longitude,
  elevation,
  avg_income_per_capita,
  unemployment_rate,
  gdp_city,
  tourism_index,
  public_transport_quality,
  major_industries,
  annual_conferences,
  international_organizations
FROM
  student32.city_economic_data_extended
ORDER BY
  name;
