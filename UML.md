# UML CLASS DIAGRAM

```mermaid
   classDiagram
  %% ================ Basis-Tabelle ================
  class country {
    +code : VARCHAR(ISO) <<PK>>
    name : TEXT
  }

  %% ================ student32 Schema ================
  subgraph student32
    class currency {
      +code : VARCHAR(3) <<PK>>
      name : TEXT
      exchange_rate : NUMERIC
      country_code : VARCHAR(4) <<FK>>
    }
    class gdp {
      +id : SERIAL <<PK>>
      year : INT
      country_code : VARCHAR(4) <<FK>>
      amount : NUMERIC
      currency_code : VARCHAR(3) <<FK>>
    }
    class inflation {
      +id : SERIAL <<PK>>
      year : INT
      country_code : VARCHAR(4) <<FK>>
      rate : NUMERIC
    }
  end

  %% student32 Beziehungen
  country "1" o-- "0..*" currency        : country_code
  currency "1" o-- "0..*" gdp           : currency_code
  country  "1" o-- "0..*" gdp           : country_code
  country  "1" o-- "0..*" inflation     : country_code

  %% ================ default Schema ================
  subgraph default
    class CountryStats {
      +year : INT <<PK>>
      +country : TEXT
      debt_amount : NUMERIC(15,2)
      debt_currency : TEXT
      internet_usage : NUMERIC(5,2)
      co2_per_person : NUMERIC(15,2)
      co2_unit : TEXT
    }
    class country_trade_industry {
      +id : SERIAL <<PK>>
      year : INT
      country : VARCHAR(100)
      export_amount : NUMERIC(10,2)
      export_products : TEXT
      import_amount : NUMERIC(10,2)
      import_products : TEXT
      industry_share_percent : NUMERIC(5,2)
    }
  end

  %% ================ BIS2161 Schema ================
  subgraph BIS2161
    class unemployment {
      +unemployment_id : SERIAL <<PK>>
      country_code : CHAR(2) <<FK>>
      country_name : VARCHAR(100)
      year : SMALLINT
      unemployment_rate : NUMERIC(5,2)
    }
    class average_salary {
      +average_salary_id : SERIAL <<PK>>
      country_code : CHAR(2) <<FK>>
      country_name : VARCHAR(100)
      year : SMALLINT
      amount : NUMERIC(12,2)
      currency_name : VARCHAR(50)
    }
    class minimum_wage {
      +minimum_wage_id : SERIAL <<PK>>
      country_code : CHAR(2) <<FK>>
      country_name : VARCHAR(100)
      year : SMALLINT
      amount : NUMERIC(12,2)
      currency_name : VARCHAR(50)
    }
  end

  %% BIS2161 Beziehungen
  country "1" o-- "0..*" unemployment    : country_code
  country "1" o-- "0..*" average_salary  : country_code
  country "1" o-- "0..*" minimum_wage     : country_code
