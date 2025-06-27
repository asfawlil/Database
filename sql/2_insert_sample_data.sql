/* -----------------------------------------------------------------------------
   FILE:    2_insert_sample_data.sql
   PURPOSE: Insert example data into currency, gdp, and inflation tables
   SCHEMA:  student32 (Economy Project)
   AUTHOR:  Njomza Bytyqi (student32 / 330021)
   NOTES:   Provides sample records for currencies, GDP figures, and inflation rates
----------------------------------------------------------------------------- */

-- ============================================================================
-- SECTION: Sample Currencies
--   • code:        ISO currency code
--   • name:        Currency name
--   • exchange_rate: Exchange rate vs. USD
--   • country_code: ISO country code
-- ============================================================================
INSERT INTO student32.currency (code, name, exchange_rate, country_code) VALUES
    ('EUR', 'Euro',           1.07, 'DEU'),  -- Germany
    ('GBP', 'British Pound',  1.25, 'GBR'),  -- United Kingdom
    ('CHF', 'Swiss Franc',    1.10, 'CHE');  -- Switzerland
    

-- ============================================================================
-- SECTION: Sample GDP Values
--   • year:         Year of measurement
--   • country_code: ISO country code
--   • amount:       GDP in billions of local currency
--   • currency_code: Currency code used
-- ============================================================================
INSERT INTO student32.gdp (year, country_code, amount, currency_code) VALUES
    (2023, 'DEU', 4295.0, 'EUR'),  -- Germany
    (2023, 'GBR', 3131.0, 'GBP'),  -- United Kingdom
    (2023, 'FRA', 3005.0, 'EUR'),  -- France
    (2023, 'ITA', 2182.0, 'EUR'),  -- Italy
    (2023, 'BEL',  625.0, 'EUR'),  -- Belgium
    (2023, 'AUT',  520.0, 'EUR'),  -- Austria
    (2023, 'CHE',  824.0, 'CHF'),  -- Switzerland
    (2023, 'ESP', 1614.0, 'EUR');  -- Spain

-- ============================================================================
-- SECTION: Sample Inflation Rates
--   • year:         Year of measurement
--   • country_code: ISO country code
--   • rate:         Inflation rate in percent
-- ============================================================================
INSERT INTO student32.inflation (year, country_code, rate) VALUES
    (2023, 'DEU', 5.9),  -- Germany
    (2023, 'GBR', 7.3),  -- United Kingdom
    (2023, 'FRA', 5.2),  -- France
    (2023, 'ITA', 6.7),  -- Italy
    (2023, 'BEL', 4.9),  -- Belgium
    (2023, 'AUT', 8.1),  -- Austria
    (2023, 'CHE', 2.2),  -- Switzerland
    (2023, 'ESP', 3.4);  -- Spain
