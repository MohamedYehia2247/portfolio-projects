-- Query to retrieve data for all locations with cases and deaths data
select location, date, total_cases,total_deaths , population from dbo.['owid-covid-data$']
where continent is not null
order by 1,2


-- Query to retrieve data for Egypt with death percentage

select location, date, total_cases,total_deaths , round((total_deaths/total_cases)*100,2) as death_percentage  from dbo.['owid-covid-data$']
where continent is not null
where location= 'egypt'
order by 1,2


-- Query to retrieve data for Egypt with population infected percentage

select location, date, total_cases,population , round((total_cases/population)*100,2) as population_infected_percentage from dbo.['owid-covid-data$']
where continent is not null
where location= 'egypt'
order by 1,2


-- Query to retrieve data for countries with the highest infection percentage compared to population

select location,population,  max(total_cases) as highest_infection  , max(total_cases/population)*100 as population_infected_percentage from dbo.['owid-covid-data$']
where continent is not null
group by location,population 
order by population_infected_percentage desc



-- Query to retrieve data for locations with the highest total death count

select location, MAX(cast(Total_deaths as int)) as TotalDeathCount   from dbo.['owid-covid-data$']
where continent is not null
group by location
order by totaldeathcount desc


-- Query to retrieve global death rate data

select date, sum(new_cases) as total_cases_per_day , sum(cast(new_deaths as int)) as total_deaths_per_day , 
round((sum(cast(new_deaths as int))/sum(new_cases))*100,2) as death_percentage_per_day from dbo.['owid-covid-data$']
where continent is not null
group by date 
order by 1,2



-- Query to retrieve total death and total cases overall data
select  sum(new_cases) as total_cases_per_day , sum(cast(new_deaths as int)) as total_deaths_per_day , 
round((sum(cast(new_deaths as int))/sum(new_cases))*100,2) as death_percentage_per_day from dbo.['owid-covid-data$']
where continent is not null
order by 1,2


-- Query to show percentage of population that has received at least one COVID-19 vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From dbo.['owid-covid-data$'] dea
Join[portfolio project].[dbo].[vacinations] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3

-- Query to show percentage vaccinated using CTE
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From dbo.['owid-covid-data$'] dea
Join[portfolio project].[dbo].[vacinations] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
)
Select *, (RollingPeopleVaccinated/Population)*100 
From PopvsVac
