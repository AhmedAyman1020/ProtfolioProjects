select * from coviddeath
where continent is not null 
order by date

--select * from vaccination
--order by date 

--selcet date that we are bring to be used
select location, date,population,new_cases,total_cases,total_deaths from coviddeath
where continent is not null 

--looking for total cases vs total deaths
select location,date,total_cases,total_deaths,(cast(total_deaths as float)/cast(total_cases as float))*100 as percent_of_deaths from coviddeath
where location like 'Egypt'
order by total_deaths desc

--looking at total_cases vs population
select location,date,population,cast(total_cases as int) as total_cases,(cast(total_cases as float)/population)*100 as percent_got_covid from coviddeath
where location like 'Egypt'
order by 3,4 

--looking at counteries taht highest infection rate compared population
select location,population,max(cast(total_cases as float)) as max_cases,(max(cast(total_cases as float))/population)*100 as highest_infected_counteries from coviddeath
where continent is not null 
group by location,population  
 
 --showing higest countiers deaths per popualtion
 select location,max(cast(total_deaths as float)) as max_deaths from coviddeath
 where continent is not null 
group by location
order by location desc

--breaking things by contient 
 select continent,max(cast(total_deaths as float)) as max_deaths from coviddeath
 where continent is not null 
group by continent
order by continent desc

--showing conteries with the higiest death count per population
 select continent,max(cast(total_deaths as float)) as max_deaths from coviddeath
 where continent is not null 
group by continent
order by continent desc
 
 --global numbers
 select sum (cast(new_cases as int)) as new_cases, sum(cast(new_deaths as int)) as new_deaths from coviddeath
where continent is not null

select * from coviddeath de
join vaccination va
on de.location = va.location
and de.date = va.date

--looking at total population vs vacciation
select de.continent,de.location,de.date,de.population,va.new_vaccinations,
sum(convert (float,new_vaccinations)) OVER (partition by de.location order by de.location, de.date) as rollingpeoplevaccinated  
from coviddeath de
join vaccination va
on de.location = va.location
and de.date = va.date
where de.continent is not null 

--use cte 
 with popvsvac (continent,lovation,date,population,new_vaccinations,rollingpeoplevaccinated)
 as 
 (
select de.continent,de.location,de.date,de.population,va.new_vaccinations,
sum(convert (float,new_vaccinations)) OVER (partition by de.location order by de.location, de.date) as rollingpeoplevaccinated  
from coviddeath de
join vaccination va
on de.location = va.location
and de.date = va.date
where de.continent is not null 
)
select *,(rollingpeoplevaccinated/population)*100 from popvsvac

--Temp Table 
create table #percentpopulationvaccinated
(
continent nvarchar(500),
location  nvarchar(500),
Date datetime,
population numeric,
new_vaccination numeric,
rollingpeoplevaccinated numeric,
)
insert into #percentpopulationvaccinated

select de.continent,de.location,de.date,de.population,va.new_vaccinations,
sum(convert (float,new_vaccinations)) OVER (partition by de.location order by de.location, de.date) as rollingpeoplevaccinated  
from coviddeath de
join vaccination va
on de.location = va.location
and de.date = va.date
where de.continent is not null 

select *,(rollingpeoplevaccinated/population)*100 from #percentpopulationvaccinated

--creating view to store date for later visulization
create view percentpopulationvaccinated
as         
select de.continent,de.location,de.date,de.population,va.new_vaccinations,
sum(convert (float,new_vaccinations)) OVER (partition by de.location order by de.location, de.date) as rollingpeoplevaccinated  
from coviddeath de
join vaccination va
on de.location = va.location
and de.date = va.date
where de.continent is not null 

select * from percentpopulationvaccinated





