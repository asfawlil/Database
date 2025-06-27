-- ---------------------------------------------------------------
-- Labor Market Data – Sample Entries for the Year 2023
-- Author: Liliana Asfaw (student38)
-- Data set for comparison and analysis in the Mondial extension
-- ---------------------------------------------------------------

-- Insert annual unemployment rates for a diverse set of countries (year = 2023)
-- Explicit country codes ensure correct FK linkage; realistic mix of low and high values
INSERT INTO student38.unemployment (country_code, country_name, year, unemployment_rate) VALUES
  ('D',  'Germany',       2023, 5.7),   -- Germany: moderate unemployment
  ('GB', 'United Kingdom',2023, 4.2),   -- UK: lower unemployment
  ('F',  'France',        2023, 7.1),   -- France: above-average rate
  ('I',  'Italy',         2023, 8.5),   -- Italy: higher rate for testing
  ('B',  'Belgium',       2023, 5.6),   -- Belgium: similar to Germany
  ('A',  'Austria',       2023, 4.9),   -- Austria: low rate
  ('CH', 'Switzerland',   2023, 2.1),   -- Switzerland: very low unemployment
  ('E',  'Spain',         2023,12.3);   -- Spain: high unemployment

-- Insert average gross annual salaries in local currency (year = 2023)
-- Consistent formatting of amount and currency for clear economic comparison
INSERT INTO student38.average_salary (country_code, country_name, year, amount, currency_name) VALUES
  ('D',  'Germany',       2023, 43200.00, 'EUR'),  -- Germany average salary
  ('GB', 'United Kingdom',2023, 38700.00, 'GBP'),  -- UK average salary
  ('F',  'France',        2023, 39600.00, 'EUR'),  -- France average salary
  ('I',  'Italy',         2023, 32500.00, 'EUR'),  -- Italy average salary
  ('B',  'Belgium',       2023, 41000.00, 'EUR'),  -- Belgium average salary
  ('A',  'Austria',       2023, 43800.00, 'EUR'),  -- Austria average salary
  ('CH', 'Switzerland',   2023, 62400.00, 'CHF'),  -- Switzerland average salary
  ('E',  'Spain',         2023, 29500.00, 'EUR');  -- Spain average salary

-- Insert statutory minimum wages (monthly) where applicable (year = 2023)
-- NULL values indicate absence of a national minimum wage policy
INSERT INTO student38.minimum_wage (country_code, country_name, year, amount, currency_name) VALUES
  ('D',  'Germany',       2023, 2080.00, 'EUR'),  -- Germany monthly minimum wage
  ('GB', 'United Kingdom',2023, 1760.00, 'GBP'),  -- UK monthly minimum wage
  ('F',  'France',        2023, 1709.00, 'EUR'),  -- France monthly minimum wage
  ('I',  'Italy',         2023,    NULL, 'EUR'),  -- Italy: no statutory minimum wage
  ('B',  'Belgium',       2023, 1995.00, 'EUR'),  -- Belgium monthly minimum wage
  ('A',  'Austria',       2023,    NULL, 'EUR'),  -- Austria: no statutory minimum wage
  ('CH', 'Switzerland',   2023,    NULL, 'CHF'),  -- Switzerland: no statutory minimum wage
  ('E',  'Spain',         2023, 1260.00, 'EUR');  -- Spain monthly minimum wage
