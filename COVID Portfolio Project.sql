SELECT *
FROM covid_death
ORDER BY 3,4;

/*SELECT *
FROM covidvaccination
ORDER BY 3,4;*/


SELECT location, date, total_cases, new_cases,total_deaths, population
FROM covid_death;

-- Total Cases vs Total

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
FROM covid_death
ORDER BY 1,2;


-- Total Cases vs Population;
SELECT location, date, total_cases, population, (total_cases/population)*100 as Population_Percent_Infected
FROM covid_death
WHERE location LIKE "%Nigeria%"
ORDER BY 1,2;

-- Countries with highest infection rate

SELECT location, population,  max(total_cases) as Highest_Infected_Count, max((total_cases/population)*100) as Population_Percent_Infected
FROM covid_death
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY location DESC;

-- Countries with the highest death per population

SELECT location, population,  max(total_deaths) as Highest_death_Count, max((total_deaths/population)*100) as Population_Percent_death
FROM covid_death
GROUP BY location, population
ORDER BY Population_Percent_death DESC;

-- countries and their total death;

SELECT location, population, sum(new_deaths) as Total_Death_Count
FROM covid_death
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY Total_Death_Count DESC;

-- Total death by continent
SELECT continent, sum(new_deaths) as Total_Death_Count
FROM covid_death
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY Total_Death_Count DESC;

-- Global numbers
   -- Total Cases and death by day
SELECT date, sum(new_cases) as Total_Case, sum(new_deaths) as Total_death
FROM covid_death
GROUP BY date
ORDER BY 1;

-- Total Cases and Death in the world
SELECT sum(new_cases) as Total_Case, sum(new_deaths) as Total_death, sum(new_deaths)/sum(new_cases)*100 as Death_percentage
FROM covid_death;
-- GROUP BY date
-- ORDER BY 1;



-- CTE--Total population vs Vacination
WITH PopVSVac (continent, location, date, population, new_vaccinations, cummulative_vacinated)
as
 (
SELECT cod.continent, cod.location, cod.date, cod.population, cov.new_vaccinations,
SUM(cov.new_vaccinations) OVER (PARTITION BY cod.location ORDER BY  cod.location, cod.date) as cummulative_vacinatedd
FROM covid_death cod
JOIN covidvaccination cov
ON cod.date=cov.date
AND cod.location=cov.location
WHERE cod.continent is not null
 ORDER BY 2,3
 )
SELECT *, (cummulative_vacinated/population)*100 as Percent_Vaccinated
FROM PopVSVac;


-- Creating some views for later visualization
CREATE VIEW TotalCasesVsTotalDeath as
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
FROM covid_death
ORDER BY 1,2;

CREATE VIEW TotalWordCase_V_SDeath as
SELECT sum(new_cases) as Total_Case, sum(new_deaths) as Total_death, sum(new_deaths)/sum(new_cases)*100 as Death_percentage
FROM covid_death;

CREATE VIEW ContinentDeaths as
SELECT continent, sum(new_deaths) as Total_Death_Count
FROM covid_death
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY Total_Death_Count DESC;