select *
from worldlifexpectancy;

select country, min(lifeexpectancy), max(lifeexpectancy), round(max(lifeexpectancy) - min(lifeexpectancy),1) as LE_Increase
from worldlifexpectancy
group by country  
having min(lifeexpectancy) <> 0
	and max(lifeexpectancy) <> 0
order by LE_Increase desc 
		-- This code outputs the Min, Max and the LE increase over the last 15 years. It excludes records where LE is 0, and orders the results by LE_Increase desc, with the greatest LE Increase at the top
;
        
select year, round(avg(lifeexpectancy),1)
from worldlifexpectancy
group by year
having round(avg(lifeexpectancy),1) <> 0
order by year
		-- This code displays the average LE of all countries over the last 15 years
;
        
SELECT 
    d.year,
    ROUND(d.avg_lifeexpectancy, 1) AS developed_lifeexpectancy,
    ROUND(dp.avg_lifeexpectancy, 1) AS developing_lifeexpectancy -- This is what will appear in the output
FROM 
    (SELECT year, AVG(lifeexpectancy) AS avg_lifeexpectancy
     FROM worldlifexpectancy
     WHERE status = 'Developed'
     and lifeexpectancy <> 0
     GROUP BY year) d -- This subquery generates the first table, filtering it to only show Developed countries and where LE does not = 0
LEFT JOIN -- Joins the left (first table) to ensure all developed countries are shown even if there are no corresponding ones in Dp
    (SELECT year, AVG(lifeexpectancy) AS avg_lifeexpectancy
     FROM worldlifexpectancy
     WHERE status = 'Developing'
     and lifeexpectancy <> 0
     GROUP BY year) dp -- This subquery generates the second table, filtering it to only show Developing Countries and where LE != 0
ON d.year = dp.year -- Joins the table by linking the two 'year' columns
ORDER BY d.year;
		-- This code compares the average LE of developed countries vs developing countries in each of the last 15 years
;

Select country, 
		round(avg(lifeexpectancy),1) as Avg_LE, 
		round(avg(GDP),1) as Avg_GDP
from worldlifexpectancy
group by country
having  avg(lifeexpectancy) <> 0
and avg(GDP) <> 0
order by Avg_GDP
;

WITH RankedGDP AS (
  SELECT GDP, ROW_NUMBER() OVER (ORDER BY GDP) AS RowAsc,
         ROW_NUMBER() OVER (ORDER BY GDP DESC) AS RowDesc
  FROM worldlifexpectancy
) -- Generates the table 'RankedGDP', with columns of asc and desc row numbers. This will rank the values and help find the middle value
SELECT AVG(GDP) AS MedianValue
FROM RankedGDP
WHERE RowAsc = RowDesc 
OR RowAsc + 1 = RowDesc; -- Computes the median. If there's an odd number of rows, it will use RowDesc, if an even, it will use RowAsc +1.
;
	-- This code finds the median value of GDP and can help with other exploratory analysis

select 
SUM(case when GDP >= 1172 then 1 else 0 end) High_GDP_Count,
round(avg(case when GDP >= 1172 then lifeexpectancy else null end),1) High_GDP_LE,
SUM(case when GDP < 1172 then 1 else 0 end) Low_GDP_Count,
round(avg(case when GDP < 1172 then lifeexpectancy else null end),1) Low_GDP_LE
from worldlifexpectancy;
	-- This code compares the number of High GDP countries and their avg LE against the number of Low GDP countries and their avg LE
   
   select country, round(avg(BMI),1)
   from worldlifexpectancy
   group by country 
   having avg(BMI) != 0
   order by avg(BMI); -- Shows the average BMI of all countries
   
select 
SUM(case when BMI >= 38 then 1 else 0 end) High_BMI_Count,
round(avg(case when BMI >= 38 then lifeexpectancy else null end),1) High_BMI_LE,
SUM(case when BMI < 38 then 1 else 0 end) Low_BMI_Count,
round(avg(case when BMI < 38 then lifeexpectancy else null end),1) Low_BMI_LE
from worldlifexpectancy;
	-- This code compares the number of High BMI countries and their avg LE against the number of Low BMI countries and their avg LE


select country, round(avg(lifeexpectancy),1) as LE, round(avg(BMI),1) as BMI
from worldlifexpectancy
group by country
having LE > 0 
and BMI > 0
order by BMI desc;
	-- This displays the countries with the highest BMI desc, along with their LE

select country, year, lifeexpectancy, AdultMortality,
		sum(AdultMortality) over(partition by country order by year) as AM_Rolling_Total
from worldlifexpectancy
	-- Shows a rolling total of the AM, where the total of AM is partitioned for each country
    

