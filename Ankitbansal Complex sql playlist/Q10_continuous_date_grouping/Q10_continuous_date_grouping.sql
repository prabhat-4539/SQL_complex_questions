/*
create table tasks (
date_value date,
state varchar(10)
);

insert into tasks  values ('2019-01-01','success'),('2019-01-02','success'),('2019-01-03','success'),('2019-01-04','fail')
,('2019-01-05','fail'),('2019-01-06','success')
*/

--SELECT * from tasks

WITH consolidated_data AS
(
SELECT 
	date_value, 
	state,
	DATEADD(day, -ROW_NUMBER() OVER (partition by state order by date_value), date_value) AS base_date
FROM tasks
)
SELECT 
	MIN(date_value) AS Start_Date,
	MAX(date_value) AS End_Date,
	state
FROM consolidated_data
GROUP BY state, base_date
ORDER BY Start_Date




