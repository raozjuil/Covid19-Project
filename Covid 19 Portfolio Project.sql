
select *
from PortfolioProject..covid_deaths
order by 3,4

--select *
--from PortfolioProject..covid_vaccinations
--order by 3,4

select location,date,total_cases,new_cases,total_deaths,population
from PortfolioProject..covid_deaths
order by 1,2

-- Looking at total cases vs total deaths

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..covid_deaths
where location = 'India'
order by 1,2

-- Looking at the total cases vs population

select location,date,total_cases,population,(total_cases/population)*100 as CovidPercentage
from PortfolioProject..covid_deaths
where location = 'India'


--  Looking at countries with highest infection rate comapred to poupulation

select location,population,max(total_cases) as HighestInfectionCount,max((total_cases/population))*100 as CovidPercentageInfected
from PortfolioProject..covid_deaths
group by location,population
order by CovidPercentageInfected desc

--  Looking at countries with highest death count comapred to poupulation

select location,max(cast(total_deaths as int)) as HighestDeathCount --max((total_deaths/population))*100 as PercentahgePopulationDied
from PortfolioProject..covid_deaths
where continent is not null
group by location
order by HighestDeathCount desc

-- Showing the continenet with highest death count

select location,max(cast(total_deaths as int)) as HighestDeathCount --max((total_deaths/population))*100 as PercentahgePopulationDied
from PortfolioProject..covid_deaths
where continent is null
group by location
order by HighestDeathCount desc

-- Global Numbers

select date,sum(new_cases) as total_cases,sum(cast(new_deaths as int)) as total_deaths,sum(cast(new_deaths as int))/sum(new_cases)
*100 as DeathPercentage
from PortfolioProject..covid_deaths
--where location = 'India'
where continent is not null
group by date
order by 1,2

-- Looking at total population vs Vaccinations
with PopvsVac (Continent,Location,Date,Population,New_Vaccinations,RollingPeopleVaccinated)
as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(cast(new_vaccinations as int)) over
(partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from PortfolioProject..covid_deaths dea
join PortfolioProject..covid_vaccinations vac
on dea.location= vac.location
and dea.date = vac.date
where dea.continent is not null and dea.location = 'India'
--order by 2,3
)
select *,(RollingPeopleVaccinated/population)*100
from PopvsVac

-- Creating views for visualizations

create view PercentagePopulationVaccinated as
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(cast(new_vaccinations as int)) over
(partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from PortfolioProject..covid_deaths dea
join PortfolioProject..covid_vaccinations vac
on dea.location= vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3


select * from PercentagePopulationVaccinated


