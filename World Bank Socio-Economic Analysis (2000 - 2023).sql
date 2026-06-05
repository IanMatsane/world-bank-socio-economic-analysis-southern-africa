-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                                                                                      -- 1. DATA CLEANING
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Fixing incorrect capital city spelling.

UPDATE world_bank_socioeconomic_indicators.countries
SET capital_city = 'Gaborone'
WHERE country_name = 'Botswana';

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
										                                             -- 2. DATA OVERVIEW
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Tables check
SELECT * FROM world_bank_socioeconomic_indicators.countries;
SELECT * FROM world_bank_socioeconomic_indicators.gdp;
SELECT * FROM world_bank_socioeconomic_indicators.technology;
SELECT * FROM world_bank_socioeconomic_indicators.population_health;

-- Sample data
SELECT * FROM world_bank_socioeconomic_indicators.gdp
LIMIT 5;

-- Row counts
SELECT COUNT(*)
FROM world_bank_socioeconomic_indicators.gdp;
			                  
-- Range check
SELECT MIN(Year), MAX(Year) FROM world_bank_socioeconomic_indicators.gdp;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
										                                           -- 3. DATA ANALYSIS
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Top 3 economies by GDP (US Dollers) in the latest year
SELECT Country_name, Year, gdp_usd 
FROM world_bank_socioeconomic_indicators.gdp
JOIN world_bank_socioeconomic_indicators.countries 
	ON gdp.Country_Id = countries.Country_Id 
	WHERE Year = (SELECT MAX(Year) FROM world_bank_socioeconomic_indicators.gdp)
	ORDER BY gdp_usd DESC
	LIMIT 3;

-- GDP per capita (US Dollers) in the latest year
SELECT Country_name, gdp_usd/population_total AS gdp_per_capita 
FROM world_bank_socioeconomic_indicators.gdp
JOIN world_bank_socioeconomic_indicators.population_health 
	ON gdp.Country_Id = population_health.Country_Id AND gdp.year = population_health.year
JOIN world_bank_socioeconomic_indicators.countries
	ON gdp.country_id = countries.country_id
    WHERE gdp.year = (SELECT MAX(year) FROM world_bank_socioeconomic_indicators.gdp)
	ORDER BY gdp_per_capita DESC;

-- The fastest growing economies from 2000 to 2023 (Average GDP growth)
SELECT Country_name, AVG(gdp_growth_pct) AS Average_growth_pct 
FROM world_bank_socioeconomic_indicators.gdp
JOIN world_bank_socioeconomic_indicators.countries 
	ON gdp.Country_Id = countries.Country_Id
    WHERE Year BETWEEN 2000 AND 2023
    GROUP BY country_name
	ORDER BY Average_growth_pct DESC;
    
-- Economy (GDP in US Dollers) vs Unemployment rate in the latest year
SELECT Country_name, Year, gdp_usd, Unemployment_rate_pct 
FROM world_bank_socioeconomic_indicators.gdp
JOIN world_bank_socioeconomic_indicators.countries 
	ON gdp.Country_Id = countries.Country_Id 
	WHERE Year = (SELECT MAX(Year) FROM world_bank_socioeconomic_indicators.gdp)
	ORDER BY gdp_usd DESC;

-- Economy (GPD in US Dollers) and Socio-economic development in the latest year
SELECT country_name, gdp_usd, population_total, life_expectancy_years, health_expenditure_pct_gdp
FROM world_bank_socioeconomic_indicators.gdp
JOIN world_bank_socioeconomic_indicators.population_health
	ON gdp.country_id = population_health.country_id AND gdp.year = population_health.year
JOIN world_bank_socioeconomic_indicators.countries
	ON gdp.country_id = countries.country_id
WHERE gdp.year = (SELECT MAX(year) FROM world_bank_socioeconomic_indicators.gdp)
ORDER BY gdp_usd DESC;

-- Internet Development in the latest year
SELECT country_name, internet_users_pct
FROM world_bank_socioeconomic_indicators.technology
LEFT JOIN world_bank_socioeconomic_indicators.countries
	ON technology.country_id = countries.country_id
WHERE technology.year = (SELECT MAX(year) FROM world_bank_socioeconomic_indicators.technology)
ORDER BY technology.internet_users_pct DESC;

-- Key insights and relationships in the latest year
SELECT country_name, gdp_usd, gdp_growth_pct, internet_users_pct
FROM world_bank_socioeconomic_indicators.gdp
LEFT JOIN world_bank_socioeconomic_indicators.technology
	ON gdp.country_id = technology.country_id AND gdp.year = technology.year
LEFT JOIN world_bank_socioeconomic_indicators.countries
	ON gdp.country_id = countries.country_id
WHERE gdp.year = (SELECT MAX(year) FROM world_bank_socioeconomic_indicators.gdp);



    

 