-- 06_consistency_conditions.sql
-- @author: student32 / Njomza Bytyqi 330021

-- currency-Tabelle
CREATE TABLE student32.currency (
    code VARCHAR(3) PRIMARY KEY,
    -- Surrogater Primärschlüssel (ISO-Code)
    name TEXT NOT NULL,
    -- Währungsname (z. B. Euro)
    exchange_rate NUMERIC CHECK (exchange_rate > 0),
    -- Wechselkurs in USD, nur positive Werte
    country_code VARCHAR(4) NOT NULL
    -- ISO-Code des Landes (z. B. DEU)
    -- 1NF: Alle Werte atomar
    -- 2NF: Alle Attribute hängen direkt vom PK ab
    -- 3NF: Keine transitiven Abhängigkeiten
);

-- gdp-Tabelle
CREATE TABLE student32.gdp (
    gdp_id SERIAL PRIMARY KEY,
    -- Surrogater Primärschlüssel
    year INT NOT NULL,
    -- Jahr der Angabe
    country_code VARCHAR(4) NOT NULL,
    -- ISO-Ländercode (z. B. FRA)
    amount NUMERIC CHECK (amount >= 0),
    -- BIP-Wert in Originalwährung, ≥ 0
    currency_code VARCHAR(3) NOT NULL,
    -- Währungscode (z. B. EUR)
    UNIQUE (year, country_code, currency_code)
    -- Kombination aus Jahr, Land und Währung eindeutig
    -- 1NF: Alle Felder atomar
    -- 2NF: Keine partiellen Abhängigkeiten
    -- 3NF: Keine transitiven Abhängigkeiten
);

-- inflation-Tabelle
CREATE TABLE student32.inflation (
    inflation_id SERIAL PRIMARY KEY,
    -- Surrogater Primärschlüssel
    year INT NOT NULL,
    -- Jahr der Angabe
    country_code VARCHAR(4) NOT NULL,
    -- Ländercode
    rate NUMERIC NOT NULL,
    -- Inflationsrate in Prozent
    UNIQUE (year, country_code)
    -- Jahr + Land eindeutig
    -- 1NF: rate atomar
    -- 2NF: Primärschlüssel bestimmt alle Attribute
    -- 3NF: Keine transitiven Abhängigkeiten
);

-- country-Tabelle
CREATE TABLE student32.country (
    country_code VARCHAR(4) PRIMARY KEY,
    -- Surrogater Primärschlüssel
    name VARCHAR(100) NOT NULL,
    -- Landesname (z. B. Germany)
    region VARCHAR(100),
    -- Region (optional)
    income_group VARCHAR(50)
    -- Einkommensgruppe (optional)
    -- 1NF: Alle Felder atomar
    -- 2NF: Nur ein PK, alle hängen direkt davon ab
    -- 3NF: Keine transitiven Abhängigkeiten
);

-- economic_data-Tabelle (abstrakte Oberklasse)
CREATE TABLE student32.economic_data (
    data_id SERIAL PRIMARY KEY,
    -- Surrogater Primärschlüssel
    data_type VARCHAR(20) NOT NULL CHECK (data_type IN ('GDP', 'Inflation')),
    -- Typ: GDP oder Inflation
    gdp_id INT UNIQUE,
    -- 1:1-Verknüpfung zur GDP-Tabelle
    inflation_id INT UNIQUE,
    -- 1:1-Verknüpfung zur Inflation-Tabelle
    FOREIGN KEY (gdp_id) REFERENCES student32.gdp(gdp_id) ON DELETE CASCADE,
    FOREIGN KEY (inflation_id) REFERENCES student32.inflation(inflation_id) ON DELETE CASCADE
    -- 1NF: Alle Felder atomar
    -- 2NF: Nur ein Primärschlüssel
    -- 3NF: Keine transitiven Abhängigkeiten
);