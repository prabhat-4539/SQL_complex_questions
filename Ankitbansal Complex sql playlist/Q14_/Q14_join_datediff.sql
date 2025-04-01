/*
create table users
(
user_id integer,
name varchar(20),
join_date date
);
insert into users
values (1, 'Jon', CAST('2-14-20' AS date)), 
(2, 'Jane', CAST('2-14-20' AS date)), 
(3, 'Jill', CAST('2-15-20' AS date)), 
(4, 'Josh', CAST('2-15-20' AS date)), 
(5, 'Jean', CAST('2-16-20' AS date)), 
(6, 'Justin', CAST('2-17-20' AS date)),
(7, 'Jeremy', CAST('2-18-20' AS date));

create table events
(
user_id integer,
type varchar(10),
access_date date
);

insert into events values
(1, 'Pay', CAST('3-1-20' AS date)), 
(2, 'Music', CAST('3-2-20' AS date)), 
(2, 'P', CAST('3-12-20' AS date)),
(3, 'Music', CAST('3-15-20' AS date)), 
(4, 'Music', CAST('3-15-20' AS date)), 
(1, 'P', CAST('3-16-20' AS date)), 
(3, 'P', CAST('3-22-20' AS date));
*/

WITH music_prime_users AS
(
	SELECT 
		user_id,
		type,
		access_date,
		RANK() OVER(partition by user_id order by type) AS type_rank,
		RANK() OVER(partition by user_id order by access_date) AS access_date_rank
	FROM events
	WHERE type = 'Music' or type = 'P'
)
SELECT 
	ROUND(CAST(COUNT(mp.user_id) AS DECIMAL(10,2))/CAST((SELECT COUNT(user_id) FROM events WHERE type ='music') AS DECIMAL(10,2)),2) AS user_prime_30
FROM music_prime_users mp
JOIN users u 
ON mp.user_id = u.user_id and DATEDIFF(day, u.join_date, mp.access_date) <=30
WHERE mp.type_rank = 2 and mp.access_date_rank =2
