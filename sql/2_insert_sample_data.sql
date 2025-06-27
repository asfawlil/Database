
INSERT INTO country_trade_industry (
    year, country, export_amount, export_products,
    import_amount, import_products, industry_share_percent
) VALUES
(2023, 'Germany', 1300.00, 'Machinery, Cars', 1150.00, 'Raw Materials, Electronics', 28.00),
(2023, 'UK', 950.00, 'Pharmaceuticals, Machinery', 1000.00, 'Electronics, Vehicles', 18.20),
(2023, 'France', 850.00, 'Aircraft, Luxury Goods', 870.00, 'Oil, Electronics', 20.10),
(2023, 'Italy', 650.00, 'Fashion, Machinery', 670.00, 'Electronics, Raw Materials', 22.90),
(2023, 'Belgium', 470.00, 'Chemicals, Machinery', 490.00, 'Oil, Electronics', 21.60),
(2023, 'Austria', 320.00, 'Machinery, Vehicles', 330.00, 'Machinery, Electronics', 29.00),
(2023, 'Switzerland', 420.00, 'Watches, Pharmaceuticals', 410.00, 'Medical Equipment, Oil', 26.10),
(2023, 'Spain', 540.00, 'Automobiles, Food', 550.00, 'Oil, Machinery', 21.00);


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
    -- Austria would go here
    ('CHF', 'Swiss Franc',    1.10, 'CHE');  -- Switzerland
    -- Spain (missing example)

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
