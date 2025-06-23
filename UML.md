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

    class AverageSalary {
        int id
        string country_id
        int year
        float amount
        string currency_code
    }

    class MinimumWage {
        int id
        string country_id
        int year
        float amount
        string currency_code
    }

    class PublicDebt {
        int id
        string country_id
        int year
        float amount
        float percentage_of_gdp
    }

    class InfrastructureInvestment {
        int id
        string country_id
        int year
        string sector
        float amount
    }

    class BanksPerCountry {
        int id
        string country_id
        int year
        int number_of_banks
    }

    Country "1" --> "0..*" EconomyData : has
    Country "1" --> "0..*" CountryCurrency : uses
    Currency "1" --> "0..*" CountryCurrency : used_in
    Country "1" --> "0..*" CountrySector : has
    Sector "1" --> "0..*" CountrySector : part_of
    Country "1" --> "0..*" Trade : exports
    Country "1" --> "0..*" Trade : imports
    Country "1" --> "0..*" AverageSalary : pays
    Country "1" --> "0..*" MinimumWage : guarantees
    Country "1" --> "0..*" PublicDebt : owes
    Country "1" --> "0..*" InfrastructureInvestment : invests_in
    Country "1" --> "0..*" BanksPerCountry : owns
