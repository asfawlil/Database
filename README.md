# Database - GROUP G

🌍 **Economy Factors Extension** – Mondial Database Project

This extension enhances the core [Mondial Database](https://www.dbis.cs.tu-dortmund.de/cms/de/home/Lehre/Mondial/) by incorporating key economic indicators and relationships. Developed for the BIS2161 / BIS3081 module, it bridges geographic and political data with economic insights.

## 📋 Project Overview

We introduce annual macroeconomic metrics—GDP, inflation, unemployment—alongside trade flows, currency transitions, and sector composition. Integrating these elements into the existing schema enables richer queries and analysis that combine spatial, political, and economic dimensions.

## 👥 Team Members

* Liliana Asfaw
* Njomza Bytyqi
* Grenza Beqiri
* Arlin Nerguti

# 🌐 Mini-World Description: Economic Factors in the Mondial Database

This mini-world adds an economic layer to Mondial’s geographic and political schema, focusing on:

* **Countries**: ISO-coded sovereign entities with name, area and population as a basis for all economic data.
* **Economic Indicators**: Annual values of GDP (nominal and PPP), inflation rate and unemployment rate for each country to track growth and stability over time.
* **Currency History**: Records of when countries adopt or retire currencies, including code, name, symbol and valid period (e.g. introduction of the euro).
* **Trade Relations**: Yearly import and export figures between country pairs, enabling analysis of trade balances and dependencies.
* **Sector Composition**: Percentage share of agriculture, industry and services in GDP each year to illustrate structural changes.

By weaving these elements together, the model supports queries that combine spatial, political and economic dimensions for a deeper understanding of global development.

## 🎯 Motivation

While Mondial excels at geographic and political information, adding economic factors is crucial for comprehensive global analysis. With this extension, you can:

1. Combine geographic, political, and economic data in one query.
2. Explore development paths and structural changes across countries.
3. Track trade dynamics and currency evolution over time.


## 🔐 Keys & Consistency Constraints

To ensure data integrity and avoid redundancy, the database schema defines several key constraints and validation rules.

### Primary Keys
Each table has a primary key that uniquely identifies its rows:

- `Country(id)` – ISO-style country code (e.g., 'DE', 'FR')
- `Currency(code)` – Unique currency code (e.g., 'USD', 'EUR')
- `Sector(id)` – Auto-incremented sector ID
- `EconomyData(id)` – Auto-incremented ID for each economic record
- `Trade(id)` – Auto-incremented ID for each trade entry
- `CountryCurrency(country_id, currency_code, start_year)` – Composite key for currency usage periods
- `CountrySector(country_id, sector_id, year)` – Composite key for sector share in a given year

### Foreign Keys
Relationships between entities are enforced via foreign key constraints:

- `EconomyData.country_id → Country(id)`
- `Trade.from_country_id → Country(id)`
- `Trade.to_country_id → Country(id)`
- `CountryCurrency.country_id → Country(id)`
- `CountryCurrency.currency_code → Currency(code)`
- `CountrySector.country_id → Country(id)`
- `CountrySector.sector_id → Sector(id)`

These constraints ensure that economic or trade data cannot reference non-existent countries, currencies, or sectors.

### Unique Constraints
To avoid duplicate records:

- `EconomyData` ensures one economic record per country per year:  
  `UNIQUE(country_id, year)`

### Check Constraints
To maintain valid data ranges:

- `CountrySector.share_of_gdp` must be a percentage between 0 and 100:  
  `CHECK (share_of_gdp BETWEEN 0 AND 100)`
- `Trade` prevents a country from trading with itself:  
  `CHECK (from_country_id <> to_country_id)`

### Not Null Constraints
Important fields like `Country.name` and `Currency.code` are declared `NOT NULL` to ensure they are always present.

---

These constraints collectively enforce **referential integrity**, **valid input ranges**, and **uniqueness** – ensuring the database remains consistent and accurate even during insertions or updates.

🧠 Summary

The mini-world reflects a globalized economy, where countries evolve economically, engage in trade, adopt or change currencies, and shift their industrial focus. This economic perspective enriches the existing geographic scope of the Mondial database and allows for complex querying and insightful data analysis.

