/*
  -----------------------------------------------------------------------
  -- Datei: 04_complex_queries.sql
  -- Zweck: 3 interessante & komplexe Abfragen mit garantierter Ausgabe
  -- Autorin: student38
  -----------------------------------------------------------------------
*/

-- =========================================================
-- QUERY 1: Mindestlohn im Verhältnis zum Durchschnittslohn
-- → Berechnet den Anteil des Mindestlohns am Ø-Lohn pro Land & Jahr
-- → Zeigt zusätzlich, ob ein Land unter oder über dem globalen Ø liegt
-- → Nutzt Berechnungen, Joins und ein CTE zur Vergleichseinordnung
-- =========================================================

WITH global_avg AS (
  SELECT ROUND(AVG(amount), 2) AS avg_global_salary
  FROM student38.average_salary
  WHERE amount IS NOT NULL
)
SELECT 
  a.country_name,
  m.year,
  m.amount AS min_wage,
  a.amount AS avg_salary,
  ROUND((m.amount / a.amount) * 100, 2) AS min_wage_percent,
  CASE 
    WHEN a.amount < g.avg_global_salary THEN 'Unter dem globalen Ø'
    WHEN a.amount > g.avg_global_salary THEN 'Über dem globalen Ø'
    ELSE 'Genau auf dem globalen Ø'
  END AS salary_level_global
FROM student38.minimum_wage m
JOIN student38.average_salary a 
  ON m.country_code = a.country_code AND m.year = a.year
CROSS JOIN global_avg g
WHERE m.amount IS NOT NULL AND a.amount IS NOT NULL
ORDER BY min_wage_percent DESC;


-- =========================================================
-- QUERY 2: Länder mit potenziell wirtschaftlicher Belastung
-- → Kombination von hoher Arbeitslosigkeit & niedrigem Ø-Lohn
-- → Klassifizierung in "Kritisch", "Angespannt", "Moderat"
-- → Verknüpft Daten logisch durch Bedingungen & Bewertung
-- =========================================================

SELECT 
  u.country_name,
  u.year,
  u.unemployment_rate,
  a.amount AS avg_salary,
  CASE
    WHEN u.unemployment_rate > 10 AND a.amount < 30000 THEN 'Kritisch'
    WHEN u.unemployment_rate > 6 AND a.amount < 40000 THEN 'Angespannt'
    ELSE 'Moderat'
  END AS risk_level
FROM student38.unemployment u
JOIN student38.average_salary a 
  ON u.country_code = a.country_code AND u.year = a.year
WHERE u.unemployment_rate IS NOT NULL
  AND a.amount IS NOT NULL
ORDER BY risk_level DESC, u.unemployment_rate DESC;


-- =========================================================
-- QUERY 3: Länder mit überdurchschnittlichem Mindestlohn
-- → Jährlicher Vergleich: Wo liegt der Mindestlohn über dem Jahres-Ø?
-- → Nutzt ein CTE für Gruppierung & Differenzberechnung
-- → Sortierung nach Abweichung vom Jahresmittel, begrenzt auf Top-Ergebnisse
-- =========================================================

WITH avg_per_year AS (
  SELECT 
    year, 
    ROUND(AVG(amount), 2) AS avg_min_wage_year
  FROM student38.minimum_wage
  WHERE amount IS NOT NULL
  GROUP BY year
)
SELECT 
  m.country_name,
  m.year,
  m.amount AS min_wage,
  y.avg_min_wage_year,
  ROUND(m.amount - y.avg_min_wage_year, 2) AS above_average_by
FROM student38.minimum_wage m
JOIN avg_per_year y 
  ON m.year = y.year
WHERE m.amount > y.avg_min_wage_year
ORDER BY m.year DESC, above_average_by DESC
LIMIT 5;
