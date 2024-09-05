select state_name, sum(ALand) as Land_Area, sum(AWater) as Water_Area
from USHouseholdIncome
group by state_name
order by 2 desc
limit 10;
	-- Shows the top 10 states bt Land Area. This can also be altered by ordering by 3. This would show top states by Water Area

select *
from USHouseholdIncome i
join ushouseholdincome_statistics s
	on i.id = s.id;
	-- Joins the two tables via the id columns

select i.state_name, round(avg(s.mean),1) as Average_Income, round(avg(s.median),1) as Median_Income
from USHouseholdIncome i
join ushouseholdincome_statistics s
	on i.id = s.id
group by i.state_name
Having round(avg(s.mean),1) <> 0
order by 2 desc
limit 10;
	-- Shows highest Average Income by state. Can also swap Average for Medians

select i.type, count(type), round(avg(s.mean),1) as Average_Income, round(avg(s.median),1) as Median_Income
from USHouseholdIncome i
join ushouseholdincome_statistics s
	on i.id = s.id
group by i.type
Having round(avg(s.mean),1) <> 0
	and count(type) > 100
order by 3 desc;
	-- Shows the highest Avg Income by type of households, filtering out types of households that count less than 10
    
select i.state_name, city, round(avg(s.mean),1) as Average_Income, round(avg(s.median),1) as Median_Income
from USHouseholdIncome i
join ushouseholdincome_statistics s
	on i.id = s.id
group by i.state_name, city
Having round(avg(s.mean),1) <> 0
order by 3 desc
limit 10;
	-- Shows highest Avg Income by city. Median stats show that median income may be capped at 300,000 in stats reporting