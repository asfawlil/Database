CREATE TABLE country_trade_industry (
    id SERIAL PRIMARY KEY,
    year INT NOT NULL,
    country VARCHAR(100) NOT NULL,
    export_amount NUMERIC(10, 2),
    export_products TEXT,
    import_amount NUMERIC(10, 2),
    import_products TEXT,
    industry_share_percent NUMERIC(5, 2)
);