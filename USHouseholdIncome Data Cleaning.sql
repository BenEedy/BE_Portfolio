select *
from USHouseholdIncome
where state_name = 'Alabama';

Select *
from (
	select row_id, id, 
		row_number() over(partition by id) row_num -- Assigns row numbers to all rows of ids. If there is duplicate IDs, then the row_num will be > 1
        from USHouseholdIncome) duplicates -- Names the subquery table
where row_num > 1;


delete from USHouseholdIncome
where row_id in (
Select row_id
from (
	select row_id, id, 
		row_number() over(partition by id) row_num -- Assigns row numbers to all rows of ids. If there is duplicate IDs, then the row_num will be > 1
        from USHouseholdIncome) duplicates -- Names the subquery table
where row_num > 1);
	-- Deleted duplicate row_ids
    
update USHouseholdIncome
set state_name = 'Georgia'
where state_name = 'georia'; -- Changes 'georia' to 'Georgia'

update USHouseholdIncome
set state_name = 'Alabama'
where state_name = 'alabama';

update USHouseholdIncome
set place = 'Autagaville'
where county = ''
and city = 'Vinemont';

update USHouseholdIncome
set place = 'Autagaville'
where place = 'Pine Level';

update USHouseHoldIncome
set Type = 'Borough'
where Type = 'Boroughs';

select distinct ALand, AWater
from USHouseholdIncome
where (Awater = 0 or '' or null)
or (ALand = 0 or '' or null);