SELECT country, 
       export_amount, 
       import_amount, 
       ABS(export_amount - import_amount) AS trade_gap
FROM country_trade_industry
WHERE year = 2023
ORDER BY trade_gap ASC
LIMIT 3;


SELECT country, 
       industry_share_percent, 
       export_amount
FROM country_trade_industry
WHERE year = 2023
ORDER BY industry_share_percent DESC, export_amount ASC
LIMIT 3;



SELECT country, export_products, import_products
FROM country_trade_industry
WHERE year = 2023
  AND NOT EXISTS (
    SELECT 1
    FROM regexp_split_to_table(export_products, ', ') AS e
    INTERSECT
    SELECT 1
    FROM regexp_split_to_table(import_products, ', ') AS i
  );

  