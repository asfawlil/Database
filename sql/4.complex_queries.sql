-- ---------------------------------------------------------------
-- Komplexe Auswertungen zum Arbeitsmarkt
-- Autorin: Liliana Asfaw (student38)
-- Ziel: Analyse und Vergleich arbeitsmarktrelevanter Kennzahlen 
--       wie Arbeitslosenquote, Durchschnittslohn und Mindestlohn
-- ---------------------------------------------------------------


-- Query 1: Mindestlohn im Verhältnis zum Durchschnittslohn
-- Ziel: Wie viel Prozent des Ø-Lohns macht der Mindestlohn aus?
-- Ergänzt durch Einordnung unter/über dem globalen Durchschnitt
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

-- Query 2: Wirtschaftlich angespannte Länder
-- Ziel: Kombination aus hoher Arbeitslosigkeit & niedrigem Lohn
-- Ergebnis: Einstufung in "Kritisch", "Angespannt" oder "Moderat"
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

-- Query 3: Länder mit überdurchschnittlichem Mindestlohn
-- Ziel: Identifikation der Länder, deren Mindestlohn über dem Jahres-Ø liegt
-- Technik: CTE zur jährlichen Mittelwertberechnung, Differenzermittlung
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
