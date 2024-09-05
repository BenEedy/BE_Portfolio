SELECT * FROM World_Life_Expectancy.worldlifexpectancy;

WITH Row_num_table AS (
    SELECT 
        row_id,
        country,
        year,
        ROW_NUMBER() OVER (PARTITION BY CONCAT(country, year) ORDER BY row_id) AS Row_num
    FROM worldlifexpectancy
)
SELECT *
FROM Row_num_table
WHERE Row_num > 1; -- This identified the duplicates in the concatenated versions of the Country and Year columns

delete from worldlifexpectancy -- This used the above code to delete the row ids that were in it
where row_id in (
	WITH Row_num_table AS (
    SELECT 
        row_id,
        country,
        year,
        ROW_NUMBER() OVER (PARTITION BY CONCAT(country, year) ORDER BY row_id) AS Row_num
    FROM worldlifexpectancy
)
SELECT row_id
FROM Row_num_table
WHERE Row_num > 1
);

select *
from worldlifexpectancy
where status = '';

select distinct(country)
from worldlifexpectancy
where status = 'Developing'; -- This shows the countries that have statuses of 'Developing' (Can also swap it for 'Developed')

Update worldlifexpectancy
set status = 'Developing'
where country in 
				(select distinct(country)
from worldlifexpectancy
where status = 'Developing'); -- !! Produces an error, must find another way !! Probably because it produces a redundancy

update worldlifexpectancy t1 
join worldlifexpectancy t2 -- Joining to itself
	on t1.country = t2.country -- only include the rows where values in country columns are the same
set t1.status = 'Developed' -- set the status of the first table to 'Developed'
where t1.status = '' -- where the status of the first table is blank
and t2.status != '' -- and where the status of the second table is not blank
and t2.status = 'Developed' -- and where the status of the second table is 'Developed'
;-- These two updates replaces the status column blanks with 'Developed' or 'Developing'

select * 
from worldlifexpectancy
where lifeexpectancy = ''; -- shows all rows where there are blanks in the life expectancy column

select country, year, lifeexpectancy
from worldlifexpectancy
where lifeexpectancy = '';

select t1.country, t1.year, t1.lifeexpectancy, 
		t2.country, t2.year, t2.lifeexpectancy, 
        t3.country, t3.year, t3.lifeexpectancy,-- show these three rows. t1,2,3 refer to self-joined tables
        round((t2.lifeexpectancy + t3.Lifeexpectancy) /2,1) -- This is where we got the average life expectancy between the year before and the year after the blank row. This was then rounded to 1 decimal place. This average will be used to populate the blanks
from worldlifexpectancy t1
	join worldlifexpectancy t2
		on t1.country = t2.country -- Join t1 to t2 when the country columns are the same
        and t1.year = t2.year -1 -- Join t1 to t2 also on the year before each row
			join worldlifexpectancy t3 -- Do another join to instigate a table where the year value is one above 
				on t1.country = t3.country 
                and t1.year = t3.year +1
where t1.Lifeexpectancy = ''
;

update worldlifexpectancy t1
join worldlifexpectancy t2
		on t1.country = t2.country
        and t1.year = t2.year -1
			join worldlifexpectancy t3
				on t1.country = t3.country 
                and t1.year = t3.year +1 -- Update the table by using the join codes and setting the scene for the aggregation below
set t1.lifeexpectancy = round((t2.lifeexpectancy + t3.Lifeexpectancy) /2,1) -- Setting the lifeexpectancy row to the average of the years below and above it
where t1.lifeexpectancy = '' -- But only where the value in the lifeexpectancy column is blank
;


