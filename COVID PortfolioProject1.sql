-- Select the data I'll be using 

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeathsData
WHERE continent is not null

-- total cases vs total deaths (Shows likelihood of Death if you contract Covid per Country)

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeathsData


-- total cases vs population, Shows % of Ireland with covid for most latest date 30/04/2021 @ 5%

SELECT location, date, total_cases, population, (total_cases/population)*100 as CasePercentage
FROM PortfolioProject..CovidDeathsData
Where location like '%ireland%'
Order by date DESC


-- highest covid rate country compared to population 

SELECT location, population, MAX(total_cases) as HighestCovidCount, MAX((total_cases/population))*100 as PercentagePopulationInfected
FROM PortfolioProject..CovidDeathsData
GROUP BY location, population
Order by PercentagePopulationInfected DESC

-- Countries with highest death count per pop

SELECT location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeathsData
WHERE continent is not null
GROUP BY location
Order by TotalDeathCount DESC

--Breaking things down by continent 
---showing continents with highest deathcount

SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeathsData
WHERE continent is not null
GROUP BY continent
Order by TotalDeathCount DESC

---Global numbers

SELECT SUM(new_cases) as totalcases, SUM(cast(new_deaths as int)) as totaldeaths, SUM(cast(new_deaths as int))/SUM(new_cases) * 100 as DeathPercent
FROM PortfolioProject..CovidDeathsData
Where continent is not null
--GROUP BY date
ORDER BY 1


---Looking at total pop vs total vacs

SELECT cdd.continent, cdd.location, cdd.date, cdd.population, vac.new_vaccinations, 
SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION BY cdd.location ORDER BY cdd.location, cdd.date)
as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeathsData cdd
JOIN PortfolioProject..CovidVaccinations vac
	ON cdd.location = vac.location
	and cdd.date = vac.date
WHERE cdd.continent is not null
ORDER BY 2

---USE CTE

WITH PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
AS
(
SELECT cdd.continent, cdd.location, cdd.date, cdd.population, vac.new_vaccinations, 
SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION BY cdd.location ORDER BY cdd.location, cdd.date)
as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeathsData cdd
JOIN PortfolioProject..CovidVaccinations vac
	ON cdd.location = vac.location
	and cdd.date = vac.date
WHERE cdd.continent is not null
)
SELECT *, (RollingPeopleVaccinated/population)*100
FROM PopvsVac


--TEMP TABLE

DROP TABLE if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
Population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT into #PercentPopulationVaccinated
SELECT cdd.continent, cdd.location, cdd.date, cdd.population, vac.new_vaccinations, 
SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION BY cdd.location ORDER BY cdd.location, cdd.date)
as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeathsData cdd
JOIN PortfolioProject..CovidVaccinations vac
	ON cdd.location = vac.location
	and cdd.date = vac.date
WHERE cdd.continent is not null

SELECT *, (RollingPeopleVaccinated/population)*100
FROM #PercentPopulationVaccinated


----Creating vie for visulations later

CREATE VIEW PercentPopVaccinated as
SELECT cdd.continent, cdd.location, cdd.date, cdd.population, vac.new_vaccinations, 
SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION BY cdd.location ORDER BY cdd.location, cdd.date)
as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeathsData cdd
JOIN PortfolioProject..CovidVaccinations vac
	ON cdd.location = vac.location
	and cdd.date = vac.date
WHERE cdd.continent is not null


SELECT * 
FROM PercentPopulationVaccinated
