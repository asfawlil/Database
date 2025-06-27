-- ---------------------------------------------------------------
-- Normalization & Data Modeling
-- Author: Liliana Asfaw (student38)
-- Schema design, database normal forms (1NF–3NF),
-- Tables in 3NF including an abstract superclass
-- ---------------------------------------------------------------

-- 1. Table: Minimum Wage
CREATE TABLE student38.minimum_wage (
    minimum_wage_id SERIAL PRIMARY KEY,
    country_code CHAR(2) NOT NULL,
    country_name TEXT NOT NULL,
    year SMALLINT NOT NULL,
    amount NUMERIC CHECK (amount IS NULL OR amount >= 0),
    currency_name TEXT,
    UNIQUE (country_code, year)
);

-- 2. Table: Average Salary
CREATE TABLE student38.average_salary (
    average_salary_id SERIAL PRIMARY KEY,
    country_code CHAR(2) NOT NULL,
    country_name TEXT NOT NULL,
    year SMALLINT NOT NULL,
    amount NUMERIC CHECK (amount > 0),
    currency_name TEXT,
    UNIQUE (country_code, year)
);

-- 3. Table: Unemployment
CREATE TABLE student38.unemployment (
    unemployment_id SERIAL PRIMARY KEY,
    country_code CHAR(2) NOT NULL,
    country_name TEXT NOT NULL,
    year SMALLINT NOT NULL,
    unemployment_rate NUMERIC CHECK (unemployment_rate >= 0 AND unemployment_rate <= 100),
    UNIQUE (country_code, year)
);

-- Extended Structure: Abstract Superclass
CREATE TABLE student38.labor_data (
    data_id SERIAL PRIMARY KEY,
    data_type VARCHAR(30) NOT NULL CHECK (data_type IN ('MinimumWage', 'AverageSalary', 'Unemployment')),
    minimum_wage_id INT UNIQUE,
    average_salary_id INT UNIQUE,
    unemployment_id INT UNIQUE,
    FOREIGN KEY (minimum_wage_id) REFERENCES student38.minimum_wage(minimum_wage_id) ON DELETE CASCADE,
    FOREIGN KEY (average_salary_id) REFERENCES student38.average_salary(average_salary_id) ON DELETE CASCADE,
    FOREIGN KEY (unemployment_id) REFERENCES student38.unemployment(unemployment_id) ON DELETE CASCADE
);

-- All tables fulfill:
-- 1NF: All fields are atomic
-- 2NF: No partial dependencies
-- 3NF: No transitive dependencies
