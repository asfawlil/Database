-- ---------------------------------------------------------------
-- Normalization & Data Modeling
-- Author: Liliana Asfaw (student38)
-- Schema design, database normal forms (1NF–3NF),
-- Tables in 3NF including an abstract superclass
-- ---------------------------------------------------------------

-- Table: Minimum Wage
-- Stores statutory minimum wage by country and year
-- Enforces non-negative amounts and unique country-year combinations
CREATE TABLE student38.minimum_wage (
    minimum_wage_id SERIAL PRIMARY KEY,                  -- Surrogate key for wage records
    country_code CHAR(2) NOT NULL,                       -- ISO country code
    country_name TEXT NOT NULL,                          -- Denormalized country name
    year SMALLINT NOT NULL,                              -- Reference year
    amount NUMERIC CHECK (amount IS NULL OR amount >= 0),-- Ensures amount is non-negative if provided
    currency_name TEXT,                                  -- Currency of the wage value
    UNIQUE (country_code, year)                          -- Prevents duplicate entries per year
);

-- Table: Average Salary
-- Captures average annual salaries per country and year
-- Ensures positive salary values and one record per country-year
CREATE TABLE student38.average_salary (
    average_salary_id SERIAL PRIMARY KEY,                -- Surrogate key for salary records
    country_code CHAR(2) NOT NULL,                       -- ISO country code
    country_name TEXT NOT NULL,                          -- Denormalized country name
    year SMALLINT NOT NULL,                              -- Reference year
    amount NUMERIC CHECK (amount > 0),                   -- Validates salary is strictly positive
    currency_name TEXT,                                  -- Currency of the salary amount
    UNIQUE (country_code, year)                          -- One salary record per country-year
);

-- Table: Unemployment
-- Records unemployment rates per country and year
-- Enforces valid percentage range and uniqueness per country-year
CREATE TABLE student38.unemployment (
    unemployment_id SERIAL PRIMARY KEY,                  -- Surrogate key for unemployment records
    country_code CHAR(2) NOT NULL,                       -- ISO country code
    country_name TEXT NOT NULL,                          -- Denormalized country name
    year SMALLINT NOT NULL,                              -- Reference year
    unemployment_rate NUMERIC CHECK                     -- Validates rate is between 0 and 100%
        (unemployment_rate >= 0 AND unemployment_rate <= 100),
    UNIQUE (country_code, year)                          -- Prevents duplicate entries per year
);

-- Abstract Superclass: labor_data
-- Centralizes references to different labor metrics
-- Enforces exactly one link per record via data_type
CREATE TABLE student38.labor_data (
    data_id SERIAL PRIMARY KEY,                          -- Unique identifier for abstract entry
    data_type VARCHAR(30) NOT NULL                       -- Indicates which metric this row represents
        CHECK (data_type IN ('MinimumWage', 'AverageSalary', 'Unemployment')),
    minimum_wage_id INT UNIQUE,                          -- FK to minimum wage, one-to-one
    average_salary_id INT UNIQUE,                        -- FK to average salary, one-to-one
    unemployment_id INT UNIQUE,                          -- FK to unemployment, one-to-one
    FOREIGN KEY (minimum_wage_id) 
        REFERENCES student38.minimum_wage(minimum_wage_id) ON DELETE CASCADE,
    FOREIGN KEY (average_salary_id) 
        REFERENCES student38.average_salary(average_salary_id) ON DELETE CASCADE,
    FOREIGN KEY (unemployment_id) 
        REFERENCES student38.unemployment(unemployment_id) ON DELETE CASCADE
);

-- All tables satisfy:
-- 1NF: Fields are atomic with no repeating groups
-- 2NF: No partial dependencies on composite keys
-- 3NF: No transitive dependencies between non-key attributes
