/*
create table entries ( 
name varchar(20),
address varchar(20),
email varchar(20),
floor int,
resources varchar(10));
*/

/*
insert into entries 
values 
	('A','Bangalore','A@gmail.com',1,'CPU'),
	('A','Bangalore','A1@gmail.com',1,'CPU'),
	('A','Bangalore','A2@gmail.com',2,'DESKTOP'),
	('B','Bangalore','B@gmail.com',2,'DESKTOP'),
	('B','Bangalore','B1@gmail.com',2,'DESKTOP'),
	('B','Bangalore','B2@gmail.com',1,'MONITOR')
*/

--SELECT * FROM entries;

WITH 
resources_used_data AS
(
SELECT 
	name,
	STRING_AGG( resources, ',' ) WITHIN GROUP (ORDER BY resources) AS resources_used
FROM	(
	SELECT distinct
		name,
		resources
	FROM entries
		) distinct_entries
GROUP BY name	
),
visit_stats AS 
(
	SELECT distinct 
		name,
		COUNT(name) OVER(partition by name  ) AS Total_visits,
		floor most_visited_floor,
		COUNT(floor) OVER(partition by name,floor) AS floor_visit_count
	FROM entries
),
ranked_visit_stats AS
(
	SELECT 
		name,
		Total_visits,
		most_visited_floor,
		floor_visit_count,
		RANK() OVER(ORDER BY floor_visit_count desc) rn
	FROM visit_stats
)
select 
	v.name,
	v.Total_visits,
	v.most_visited_floor,
	r.resources_used
FROM ranked_visit_stats v
JOIN resources_used_data r
ON v.name = r.name
WHERE v.rn =1








