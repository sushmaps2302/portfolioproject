select * from [first project].[dbo].[newdeath]
where continent is not null

select * from  [first project].[dbo].[vacination]

select location,DATE,total_cases,new_cases,total_deaths,population
from [first project].[dbo].[newdeath]
where continent is not null
order by 1,2

--looking for totalcases vs total deaths
select location,DATE,total_cases,total_deaths,(total_deaths/total_cases)*100 as deathpercentage
from [first project].[dbo].[newdeath]
where location like 'indi%'
where continent is not null
order by 1,2

--total cases vs population
select location,DATE,total_cases,total_deaths,(total_cases/population)*100 as populationdeathpercentage
from [first project].[dbo].[newdeath]
where location like 'indi%'
where continent is not null
order by 1,2

--highest infection rate vs population
select continent,Max(cast(total_deaths as int)) as totaldeathcount
from [first project].[dbo].[newdeath]
where continent is not null
Group by continent
order by totaldeathcount desc

--global numbers
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
from [first project].[dbo].[newdeath]
where continent is not null 
order by 1,2

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
from [first project].[dbo].[newdeath] dea
Join [first project].[dbo].[vacination] vac
On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [first project].[dbo].[newdeath] dea
Join [first project].[dbo].[vacination] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

	
