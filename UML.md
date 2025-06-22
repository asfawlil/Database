# UML CLASS DIAGRAM

```mermaid

classDiagram
    class Country {
        string id
        string name
        int population
        float area
    }

    class EconomyData {
        int id
        int year
        float gdp
        float inflation
        float unemployment_rate
        string country_id
    }

    class Trade {
        int id
        int year
        float export_value
        float import_value
        string from_country_id
        string to_country_id
    }

    class Currency {
        string code
        string name
        string symbol
    }

    class CountryCurrency {
        string country_id
        string currency_code
        int start_year
        int end_year
    }

    class Sector {
        int id
        string name
    }

    class CountrySector {
        string country_id
        int sector_id
        int year
        float share_of_gdp
    }

    Country "1" --> "0..*" EconomyData : has
    Country "1" --> "0..*" CountryCurrency : uses
    Currency "1" --> "0..*" CountryCurrency : used_in
    Country "1" --> "0..*" CountrySector : has
    Sector "1" --> "0..*" CountrySector : part_of
    Country "1" --> "0..*" Trade : exports
    Country "1" --> "0..*" Trade : imports
