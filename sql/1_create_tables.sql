/*
Beispieldatenbank für Wirtschaftsdaten
@author: student32/ Njomza Bytyqi 330021
*/

/* =======================
   Tabelle: currency
   ======================= */

CREATE TABLE student32.currency (
    code VARCHAR(3) PRIMARY KEY,
    name TEXT NOT NULL,
    exchange_rate NUMERIC NOT NULL,  -- Wechselkurs gegenüber USD
    country_code VARCHAR(4) NOT NULL
);

/* =======================
   Tabelle: gdp
   ======================= */

CREATE TABLE student32.gdp (
    id SERIAL PRIMARY KEY,
    year INT NOT NULL,
    country_code VARCHAR(4) NOT NULL,
    amount NUMERIC NOT NULL,  -- Betrag in Originalwährung
    currency_code VARCHAR(3) NOT NULL REFERENCES student32.currency(code)
);

/* =======================
   Tabelle: inflation
   ======================= */

CREATE TABLE student32.inflation (
    id SERIAL PRIMARY KEY,
    year INT NOT NULL,
    country_code VARCHAR(4) NOT NULL,
    rate NUMERIC NOT NULL  -- Prozentwert
);