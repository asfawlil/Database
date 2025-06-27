-- Active: 1750679793034@@141.47.5.117@5432@mondial
-- ---------------------------------------------------------------
-- Module: BIS2161 / BIS3081 – Summer Semester 2025
-- Author: Liliana Asfaw (student38)
-- Topic: Economic Indicators (Unemployment, Average Salary, Minimum Wage)
-- ---------------------------------------------------------------

-- Table: unemployment
-- Stores annual unemployment rates per country (in percent)
-- Clear naming, separate ID column as PK, referential integrity to country table
CREATE TABLE unemployment (
  unemployment_id SERIAL PRIMARY KEY,                                -- Surrogate key for internal identification
  country_code CHAR(2) NOT NULL REFERENCES country(code) ON DELETE CASCADE,  -- ISO country code, ensures referential integrity
  country_name VARCHAR(100) NOT NULL,                                -- Redundant for readability, should match country table
  year SMALLINT NOT NULL,                                            -- Year of observation, 2-byte integer is space-efficient
  unemployment_rate NUMERIC(5,2)                                     -- Precision for percentage values, allows decimals like 7.50
);

-- Table: average_salary
-- Average annual salary per country and year
-- Use consistent naming and constraints, normalize currency usage where possible
CREATE TABLE average_salary (
  average_salary_id SERIAL PRIMARY KEY,                              -- Unique identifier for salary records
  country_code CHAR(2) NOT NULL REFERENCES country(code) ON DELETE CASCADE,  -- Foreign key to enforce valid country
  country_name VARCHAR(100) NOT NULL,                                -- Name redundancy for human-readable output
  year SMALLINT NOT NULL,                                            -- Year reference for time-based analysis
  amount NUMERIC(12,2) NOT NULL,                                     -- High precision salary value in local currency
  currency_name VARCHAR(50) NOT NULL                                 -- Text field for currency, could be normalized via FK
);

-- Table: minimum_wage
-- Statutory minimum wage per year (if applicable)
-- Allows NULLs for countries with no minimum wage; currency stored as plain text
CREATE TABLE minimum_wage (
  minimum_wage_id SERIAL PRIMARY KEY,                                -- Primary key using auto-increment ID
  country_code CHAR(2) NOT NULL REFERENCES country(code) ON DELETE CASCADE,  -- ISO country code for linkage
  country_name VARCHAR(100) NOT NULL,                                -- Country name for display purposes
  year SMALLINT NOT NULL,                                            -- Reference year
  amount NUMERIC(12,2),                                              -- May be NULL if minimum wage not defined
  currency_name VARCHAR(50) NOT NULL                                 -- Currency in which the wage is expressed
);
