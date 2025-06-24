/*
Komplexe Beispielabfragen zu Wirtschaftsdaten
@author: student32 / Njomza Bytyqi 330021
*/

/* 1. Länder mit Inflation > 6% im Jahr 2023 */
SELECT country_code, rate
FROM student32.inflation
WHERE year = 2023 AND rate > 6.0;

/* 2. Durchschnittliches BIP 2023 pro Währung */
SELECT g.currency_code, c.name AS currency_name, ROUND(AVG(g.amount), 2) AS avg_gdp
FROM student32.gdp g
JOIN student32.currency c ON g.currency_code = c.code
WHERE g.year = 2023
GROUP BY g.currency_code, c.name;

/* 3. Länder mit dem höchsten BIP 2023 in jeder Währungsgruppe */
SELECT g.country_code, g.amount, g.currency_code
FROM student32.gdp g
WHERE g.year = 2023 AND g.amount = (
    SELECT MAX(g2.amount)
    FROM student32.gdp g2
    WHERE g2.year = 2023 AND g2.currency_code = g.currency_code
);