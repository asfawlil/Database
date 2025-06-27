UPDATE student37.my_country SET population = 83783942 WHERE name = 'Germany';
UPDATE student37.my_country SET population = 67215293 WHERE name = 'France';
UPDATE student37.my_country SET population = 59554023 WHERE name = 'Italy';
UPDATE student37.my_country SET population = 47615034 WHERE name = 'Spain';


UPDATE student37.my_countrypops SET population = 83783942 
WHERE country = 'Germany' AND year = 2023;

UPDATE student37.my_countrypops SET population = 67215293 
WHERE country = 'France' AND year = 2023;

UPDATE student37.my_countrypops SET population = 59554023 
WHERE country = 'Italy' AND year = 2023;

UPDATE student37.my_countrypops SET population = 47615034 
WHERE country = 'Spain' AND year = 2023;


select * from country limit 10;





















UPDATE country_trade_industry SET
    export_amount = 1300.00,
    export_products = 'Machinery, Cars',
    import_amount = 1150.00,
    import_products = 'Raw Materials, Electronics',
    industry_share_percent = 28.00
WHERE year = 2023 AND country = 'Germany';

UPDATE country_trade_industry SET
    export_amount = 950.00,
    export_products = 'Pharmaceuticals, Machinery',
    import_amount = 1000.00,
    import_products = 'Electronics, Vehicles',
    industry_share_percent = 18.20
WHERE year = 2023 AND country = 'UK';

UPDATE country_trade_industry SET
    export_amount = 850.00,
    export_products = 'Aircraft, Luxury Goods',
    import_amount = 870.00,
    import_products = 'Oil, Electronics',
    industry_share_percent = 20.10
WHERE year = 2023 AND country = 'France';

UPDATE country_trade_industry SET
    export_amount = 650.00,
    export_products = 'Fashion, Machinery',
    import_amount = 670.00,
    import_products = 'Electronics, Raw Materials',
    industry_share_percent = 22.90
WHERE year = 2023 AND country = 'Italy';

UPDATE country_trade_industry SET
    export_amount = 470.00,
    export_products = 'Chemicals, Machinery',
    import_amount = 490.00,
    import_products = 'Oil, Electronics',
    industry_share_percent = 21.60
WHERE year = 2023 AND country = 'Belgium';

UPDATE country_trade_industry SET
    export_amount = 320.00,
    export_products = 'Machinery, Vehicles',
    import_amount = 330.00,
    import_products = 'Machinery, Electronics',
    industry_share_percent = 29.00
WHERE year = 2023 AND country = 'Austria';

UPDATE country_trade_industry SET
    export_amount = 420.00,
    export_products = 'Watches, Pharmaceuticals',
    import_amount = 410.00,
    import_products = 'Medical Equipment, Oil',
    industry_share_percent = 26.10
WHERE year = 2023 AND country = 'Switzerland';

UPDATE country_trade_industry SET
    export_amount = 540.00,
    export_products = 'Automobiles, Food',
    import_amount = 550.00,
    import_products = 'Oil, Machinery',
    industry_share_percent = 21.00
WHERE year = 2023 AND country = 'Spain';