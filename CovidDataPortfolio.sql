SELECT *
FROM PortfolioProject..CovidDeaths$
Where continent is not null
ORDER BY 3,4

--SELECT *
--FROM PortfolioProject..CovidVaccinations$
--ORDER BY 3,4

-- Select data that we are going to be using

SELECT location, date, total_cases, new_cases, total_deaths, population  
FROM PortfolioProject..CovidDeaths$
ORDER BY 1, 2

-- Looking at total cases vs total deaths
-- showa likelihoof of dying if you contract covid en your country
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPorcentage
FROM PortfolioProject..CovidDeaths$
where location like '%states%' 
ORDER BY 1, 2


-- Looking ar the total cases vs population
-- shows what percentage of population got covid
SELECT location, date, total_cases, population, (total_cases/population)*100 as DeathPorcentage
FROM PortfolioProject..CovidDeaths$
--where location like '%states%' 
ORDER BY 1, 2


-- Looking at Countris with highest infection rate compared to population

SELECT location, population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths$
--where location like '%states%' 
Group by Location, Population
ORDER BY PercentPopulationInfected desc


--Showing Countries with Highest Death Count per Population
SELECT location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths$
--where location like '%states%' 
Where continent is not null
Group by Location
ORDER BY TotalDeathCount desc


-- LET'S BREAK THINGS DOWN BY CONTINENT

SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths$
--where location like '%states%' 
Where continent is not null
Group by continent
ORDER BY TotalDeathCount desc


--Showing continent with highest death count per population

SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths$
--where location like '%states%' 
Where continent is not null
Group by continent
ORDER BY TotalDeathCount desc

--GLOBAL NUMBERS


SELECT sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths$ 
--where location like '%states%' 
where continent is not null
--group by date
ORDER BY 1, 2

--Looking at total population vs vaccinaations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
    On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 1,2,3

--CTE
With PopvsVac (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
    On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select*, (RollingPeopleVaccinated/Population)*100 as 
From PopvsVac


--TEMP TABLE

DROP table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(225),
Location nvarchar(255),
Date datetime,
population numeric,
new_vaccinations numeric, 
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
    On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select*, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated
Order by 2,3


--Creating view to store data for later visualizations

Create view PercentPopulationvaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
    On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Drop view PercentPopulationvaccinated