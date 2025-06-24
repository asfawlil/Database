/*
Beispieldaten für Wirtschaftstabellen: currency, gdp, inflation
@author: student32 / Njomza Bytyqi 330021
*/

/* =======================
   Beispielhafte Währungen
   ======================= */

INSERT INTO student32.currency (code, name, exchange_rate, country_code) VALUES
    ('EUR', 'Euro', 1.07, 'DEU'),        -- Deutschland
    ('GBP', 'British Pound', 1.25, 'GBR'), -- UK
           -- Österreich
    ('CHF', 'Swiss Franc', 1.10, 'CHE') -- Schweiz
    ;        -- Spanien

/* =======================
   Beispielhafte BIP-Werte (in Milliarden der Landeswährung)
   ======================= */

INSERT INTO student32.gdp (year, country_code, amount, currency_code) VALUES
    (2023, 'DEU', 4295.0, 'EUR'),
    (2023, 'GBR', 3131.0, 'GBP'),
    (2023, 'FRA', 3005.0, 'EUR'),
    (2023, 'ITA', 2182.0, 'EUR'),
    (2023, 'BEL', 625.0,  'EUR'),
    (2023, 'AUT', 520.0,  'EUR'),
    (2023, 'CHE', 824.0,  'CHF'),
    (2023, 'ESP', 1614.0, 'EUR');

/* =======================
   Beispielhafte Inflationsraten (in Prozent)
   ======================= */

INSERT INTO student32.inflation (year, country_code, rate) VALUES
    (2023, 'DEU', 5.9),
    (2023, 'GBR', 7.3),
    (2023, 'FRA', 5.2),
    (2023, 'ITA', 6.7),
    (2023, 'BEL', 4.9),
    (2023, 'AUT', 8.1),
    (2023, 'CHE', 2.2),
    (2023, 'ESP', 3.4);