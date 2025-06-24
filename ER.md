# ER MODEL

```mermaid
erDiagram
    COUNTRY ||--o{ ECONOMYDATA : has
    COUNTRY ||--o{ COUNTRYCURRENCY : uses
    CURRENCY ||--o{ COUNTRYCURRENCY : linked_with
    COUNTRY ||--o{ TRADE : exports
    COUNTRY ||--o{ TRADE : imports
    COUNTRY ||--o{ COUNTRYSECTOR : contributes
    SECTOR ||--o{ COUNTRYSECTOR : composed_of

    COUNTRY {
        string id
        string name
        int population
        float area
    }

    ECONOMYDATA {
        int id
        int year
        float gdp
        float inflation
        float unemployment_rate
        string country_id
    }

    TRADE {
        int id
        int year
        float export_value
        float import_value
        string from_country_id
        string to_country_id
    }

    CURRENCY {
        string code
        string name
        string symbol
    }

    COUNTRYCURRENCY {
        string country_id
        string currency_code
        int start_year
        int end_year
    }

    SECTOR {
        int id
        string name
    }

    COUNTRYSECTOR {
        string country_id
        int sector_id
        int year
        float share_of_gdp
    }

