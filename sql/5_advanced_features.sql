-- 05: Normalisierung & Konsistenzbedingungen
-- Autor: student32 / Njomza Bytyqi 330021

-- Tabelle: currency
-- Konsistenz: exchange_rate muss > 0 sein
ALTER TABLE student32.currency
ADD CONSTRAINT currency_exchange_rate_positive CHECK (exchange_rate > 0);

-- Tabelle: gdp
-- Konsistenz: amount (BIP) darf nicht negativ sein
ALTER TABLE student32.gdp
ADD CONSTRAINT gdp_amount_positive CHECK (amount >= 0);

-- Tabelle: inflation
-- Konsistenz: Inflationsrate darf nicht NULL sein
ALTER TABLE student32.inflation
ALTER COLUMN rate SET NOT NULL;

-- Tabelle: gdp
-- Fremdschlüssel zu currency(code)
ALTER TABLE student32.gdp
ADD CONSTRAINT gdp_currency_fk FOREIGN KEY (currency_code)
REFERENCES student32.currency(code);

-- Tabelle: gdp
-- year, country_code, currency_code als Kombination eindeutig

-- 1. Doppelte Einträge in student32.gdp löschen, jeweils nur eine Kombination behalten
DELETE FROM student32.gdp g
USING (
    SELECT MIN(id) AS id_to_keep, year, country_code, currency_code
    FROM student32.gdp
    GROUP BY year, country_code, currency_code
    HAVING COUNT(*) > 1
) dups
WHERE g.year = dups.year
  AND g.country_code = dups.country_code
  AND g.currency_code = dups.currency_code
  AND g.id <> dups.id_to_keep;

-- 2. Jetzt die UNIQUE-Constraint hinzufügen
ALTER TABLE student32.gdp
ADD CONSTRAINT gdp_unique_year_country_currency
UNIQUE (year, country_code, currency_code);



-- Tabelle: inflation
-- year, country_code Kombination eindeutig

-- 1. Doppelte Einträge in student32.inflation löschen, jeweils nur einen behalten
DELETE FROM student32.inflation i
USING (
    SELECT MIN(id) AS id_to_keep, year, country_code
    FROM student32.inflation
    GROUP BY year, country_code
    HAVING COUNT(*) > 1
) dups
WHERE i.year = dups.year
  AND i.country_code = dups.country_code
  AND i.id <> dups.id_to_keep;

-- 2. Jetzt die UNIQUE-Constraint hinzufügen
ALTER TABLE student32.inflation
ADD CONSTRAINT inflation_unique_year_country
UNIQUE (year, country_code);

-- Alle Tabellen erfüllen 1NF, 2NF und 3NF
-- Alle Felder sind atomar (1NF)
-- Es gibt keine partiellen Abhängigkeiten (2NF)
-- Keine transitiven Abhängigkeiten (3NF)