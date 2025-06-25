-- Active: 1750679793034@@141.47.5.117@5432@mondial
/*
  -----------------------------------------------------------------------
  -- Datei: 02_insert_sample_data.sql
  -- Zweck: Arbeitsmarktdaten einfügen
  -----------------------------------------------------------------------
*/

-- Arbeitslosenquote
INSERT INTO student38.unemployment (country_code, country_name, year, unemployment_rate) VALUES
('D',  'Germany',         2023, 5.7),
('GB', 'United Kingdom',  2023, 4.2),
('F',  'France',          2023, 7.1),
('I',  'Italy',           2023, 8.5),
('B',  'Belgium',         2023, 5.6),
('A',  'Austria',         2023, 4.9),
('CH', 'Switzerland',     2023, 2.1),
('E',  'Spain',           2023, 12.3);

-- Durchschnittslohn
INSERT INTO student38.average_salary (country_code, country_name, year, amount, currency_name) VALUES
('D',  'Germany',         2023, 43200.00, 'EUR'),
('GB', 'United Kingdom',  2023, 38700.00, 'GBP'),
('F',  'France',          2023, 39600.00, 'EUR'),
('I',  'Italy',           2023, 32500.00, 'EUR'),
('B',  'Belgium',         2023, 41000.00, 'EUR'),
('A',  'Austria',         2023, 43800.00, 'EUR'),
('CH', 'Switzerland',     2023, 62400.00, 'CHF'),
('E',  'Spain',           2023, 29500.00, 'EUR');


-- Mindestlohn
INSERT INTO student38.minimum_wage (country_code, country_name, year, amount, currency_name) VALUES
('D',  'Germany',         2023, 2080.00, 'EUR'),
('GB', 'United Kingdom',  2023, 1760.00, 'GBP'),
('F',  'France',          2023, 1709.00, 'EUR'),
('I',  'Italy',           2023, NULL,    'EUR'),
('B',  'Belgium',         2023, 1995.00, 'EUR'),
('A',  'Austria',         2023, NULL,    'EUR'),
('CH', 'Switzerland',     2023, NULL,    'CHF'),
('E',  'Spain',           2023, 1260.00, 'EUR');
