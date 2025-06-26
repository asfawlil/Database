CREATE TABLE CountryStats (
    year INT NOT NULL,
    country TEXT NOT NULL,           
    
    debt_amount NUMERIC(15,2),
    debt_currency TEXT,             

    internet_usage NUMERIC(5,2),

    co2_per_person NUMERIC(15,2),
    co2_unit TEXT DEFAULT 'tonnes',

    PRIMARY KEY (year, country)
);