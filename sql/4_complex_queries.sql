SELECT country, export_amount
FROM country_trade_industry
WHERE year = 2023
ORDER BY export_amount DESC
LIMIT 3;


SELECT country, export_amount, import_amount
FROM country_trade_industry
WHERE year = 2023 AND export_amount > import_amount;

SELECT country, industry_share_percent
FROM country_trade_industry
WHERE year = 2023 AND industry_share_percent > (
    SELECT AVG(industry_share_percent)
    FROM country_trade_industry
    WHERE year = 2023
);

SELECT
    SUM(export_amount) AS total_exports,
    SUM(import_amount) AS total_imports
FROM country_trade_industry
WHERE year = 2023;


SELECT
    country,
    export_amount - import_amount AS trade_balance
FROM country_trade_industry
WHERE year = 2023
ORDER BY trade_balance DESC;


SELECT country, export_products, import_products
FROM country_trade_industry
WHERE year = 2023 AND export_products = import_products;