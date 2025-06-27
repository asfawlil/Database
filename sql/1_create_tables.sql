/* -----------------------------------------------------------------------------
   FILE:    1_create_tables.sql
   PURPOSE: Defines core tables for currency, GDP, and inflation data
   SCHEMA:  student32 (Economy Project)
   AUTHOR:  Njomza Bytyqi (student32 / 330021)
   NOTES:   Contains tables for currencies, gross domestic product, and inflation.
----------------------------------------------------------------------------- */

-- ============================================================================
-- TABLE: currency
--   Stores all currencies and their exchange rate relative to USD.
--   Primary key: code (ISO currency code)
-- ============================================================================
CREATE TABLE student32.currency (
    code          VARCHAR(3) PRIMARY KEY,    -- ISO currency code, e.g. 'EUR', 'USD'
    name          TEXT        NOT NULL,      -- Name of the currency, e.g. 'Euro'
    exchange_rate NUMERIC     NOT NULL,      -- Exchange rate against USD (e.g. 1.07)
    country_code  VARCHAR(4)  NOT NULL       -- ISO country code (4 characters), e.g. 'DEU'
);

-- ============================================================================
-- TABLE: gdp
--   Stores the GDP per country and year in the local currency.
--   References currency via currency_code.
-- ============================================================================
CREATE TABLE student32.gdp (
    id            SERIAL      PRIMARY KEY,      -- Unique record identifier
    year          INT         NOT NULL,         -- Year of the data, e.g. 2023
    country_code  VARCHAR(4)  NOT NULL,         -- ISO country code (4 characters), e.g. 'DEU'
    amount        NUMERIC     NOT NULL,         -- GDP amount in local currency
    currency_code VARCHAR(3)  NOT NULL          -- Reference to currency(code)
        REFERENCES student32.currency(code)      -- Foreign key to currency table
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- ============================================================================
-- TABLE: inflation
--   Stores the annual inflation rate (percentage) per country and year.
-- ============================================================================
CREATE TABLE student32.inflation (
    id           SERIAL      PRIMARY KEY,      -- Unique record identifier
    year         INT         NOT NULL,         -- Year of inflation measurement
    country_code VARCHAR(4)  NOT NULL,         -- ISO country code (4 characters), e.g. 'DEU'
    rate         NUMERIC     NOT NULL          -- Inflation rate in percent, e.g. 5.9
);
