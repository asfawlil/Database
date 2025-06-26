/*
  -----------------------------------------------------------------------
  -- Datei: 04_sorted_tables.sql
  -- Zweck: Tabellen sortiert nach inhaltlichen Werten anzeigen
  -----------------------------------------------------------------------
*/

--  1. Arbeitslosenquote absteigend (höchste zuerst)
SELECT * 
FROM student38.unemployment
ORDER BY unemployment_rate DESC;

--  2. Durchschnittslohn absteigend (höchster Lohn zuerst)
SELECT * 
FROM student38.average_salary
ORDER BY amount DESC;

--  3. Mindestlohn absteigend (höchster Mindestlohn zuerst)
SELECT * 
FROM student38.minimum_wage
ORDER BY amount DESC NULLS LAST;


