# Database

🌍 Economy Factors Extension – Mondial Database Project

This project extends the [Mondial Database](https://www.dbis.cs.tu-dortmund.de/cms/de/home/Lehre/Mondial/) with additional entities and relationships focused on **economic factors**, as part of the BIS2161 / BIS3081 module.

## 🧾 Project Overview

We aim to model and implement economic data such as GDP, inflation, trade, currency usage, and industrial sectors, in order to provide more relevant and timely insights alongside geographical and political information.


## 👥 Team Members

- Liliana Asfaw
- Njomza Bytyqi
- Grenza Beqiri
- Arlin Nerguti





# 🌐 Mini-World Description: Economy Factors in Mondial
The mini-world describes a global database that models the economic characteristics of countries in addition to their existing geographic and political information. The extended database focuses on key macroeconomic indicators, trade relationships, currency usage, and industrial sectors, all of which vary by country and evolve over time.

🌍 Countries

Each country is a sovereign entity with basic attributes like name, area, and population. Countries are uniquely identified and serve as the central anchor for all economic data.

📈 Economy Data

Each country has economic indicators recorded annually, including:

Gross Domestic Product (GDP),
Inflation rate,
Unemployment rate,
These data points allow comparison of economic development across time and between countries.

💱 Currency

Each country uses one or more currencies over time. A currency has a unique code, name, and symbol. The historical currency usage is recorded with start and end years, supporting scenarios such as currency changes (e.g. Euro introduction).

🔁 Trade

Countries engage in international trade. Trade data is modeled as directional: for each year, the database records the value of imports and exports from one country to another. This allows analysis of bilateral trade flows and trade balances.

🏭 Sectors

Each country has various economic sectors (e.g., agriculture, services, industry), and the share of GDP for each sector is stored yearly. This helps illustrate a country’s economic structure and how it shifts over time (e.g., industrialization, service dominance).

🧠 Summary

The mini-world reflects a globalized economy, where countries evolve economically, engage in trade, adopt or change currencies, and shift their industrial focus. This economic perspective enriches the existing geographic scope of the Mondial database and allows for complex querying and insightful data analysis.


#
#


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



