-- Active: 1750679793034@@141.47.5.117@5432@mondial
-- ---------------------------------------------------------------
-- Module: BIS2161 / BIS3081 – Summer Semester 2025
-- Author: Liliana Asfaw (student38/329850)
-- Topic: Economic Indicators (Unemployment, Average Salary, Minimum Wage)
-- ---------------------------------------------------------------

-- Table: unemployment
-- Stores annual unemployment rates per country (in percent)
-- Ensures clear naming, PK, and referential integrity to country table
CREATE TABLE unemployment (
  unemployment_id SERIAL PRIMARY KEY,                              -- Surrogate key for internal identification
  country_code CHAR(2) NOT NULL REFERENCES country(code) ON DELETE CASCADE,  -- ISO country code, enforces referential integrity
  country_name VARCHAR(100) NOT NULL,                             -- Denormalized country name for readability
  year SMALLINT NOT NULL,                                         -- Year of observation, space-efficient smallint
  unemployment_rate NUMERIC(5,2)                                  -- Percentage with two decimals for precision
);

-- Table: average_salary
-- Stores average annual salary per country and year
-- Consistent naming and constraints, consider currency normalization
CREATE TABLE average_salary (
  average_salary_id SERIAL PRIMARY KEY,                           -- Unique identifier for salary records
  country_code CHAR(2) NOT NULL REFERENCES country(code) ON DELETE CASCADE,  -- Foreign key to country table
  country_name VARCHAR(100) NOT NULL,                            -- Denormalized country name for reports
  year SMALLINT NOT NULL,                                        -- Year reference for analysis
  amount NUMERIC(12,2) NOT NULL,                                 -- High-precision salary value
  currency_name VARCHAR(50) NOT NULL                             -- Currency name, could use FK for normalization
);

-- Table: minimum_wage
-- Stores statutory minimum wage per country and year
-- Allows NULLs when no minimum wage is defined
CREATE TABLE minimum_wage (
  minimum_wage_id SERIAL PRIMARY KEY,                            -- Auto-increment key for wage records
  country_code CHAR(2) NOT NULL REFERENCES country(code) ON DELETE CASCADE,  -- ISO country code FK
  country_name VARCHAR(100) NOT NULL,                            -- Denormalized country name for display
  year SMALLINT NOT NULL,                                        -- Reference year of wage
  amount NUMERIC(12,2),                                          -- Wage amount, nullable if undefined
  currency_name VARCHAR(50) NOT NULL                             -- Currency context for the wage
);
