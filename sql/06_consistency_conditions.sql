-- Datei: 06_consistency_modeling.sql
-- Zweck: Normalisierung und Datenmodellierung (Aufgabe 5)
-- Autor: student38

-- Tabellen in 3NF anlegen

-- 1. Tabelle: Minimum Wage
CREATE TABLE student38.minimum_wage (
    minimum_wage_id SERIAL PRIMARY KEY,
    country_code CHAR(2) NOT NULL,
    country_name TEXT NOT NULL,
    year SMALLINT NOT NULL,
    amount NUMERIC CHECK (amount IS NULL OR amount >= 0),
    currency_name TEXT,
    UNIQUE (country_code, year)
);

-- 2. Tabelle: Average Salary
CREATE TABLE student38.average_salary (
    average_salary_id SERIAL PRIMARY KEY,
    country_code CHAR(2) NOT NULL,
    country_name TEXT NOT NULL,
    year SMALLINT NOT NULL,
    amount NUMERIC CHECK (amount > 0),
    currency_name TEXT,
    UNIQUE (country_code, year)
);

-- 3. Tabelle: Unemployment
CREATE TABLE student38.unemployment (
    unemployment_id SERIAL PRIMARY KEY,
    country_code CHAR(2) NOT NULL,
    country_name TEXT NOT NULL,
    year SMALLINT NOT NULL,
    unemployment_rate NUMERIC CHECK (unemployment_rate >= 0 AND unemployment_rate <= 100),
    UNIQUE (country_code, year)
);

-- Erweiterte Struktur: Abstrakte Oberklasse
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

-- Alle Tabellen erfüllen:
-- 1NF: Alle Felder atomar 
-- 2NF: Keine partiellen Abhängigkeiten 
-- 3NF: Keine transitiven Abhängigkeiten
