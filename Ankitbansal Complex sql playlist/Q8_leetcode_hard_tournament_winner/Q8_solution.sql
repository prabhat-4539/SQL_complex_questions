/*create table players
(player_id int,
group_id int)

insert into players values (15,1);
insert into players values (25,1);
insert into players values (30,1);
insert into players values (45,1);
insert into players values (10,2);
insert into players values (35,2);
insert into players values (50,2);
insert into players values (20,3);
insert into players values (40,3);

create table matches
(
match_id int,
first_player int,
second_player int,
first_score int,
second_score int)

insert into matches values (1,15,45,3,0);
insert into matches values (2,30,25,1,2);
insert into matches values (3,30,15,2,0);
insert into matches values (4,40,20,5,2);
insert into matches values (5,35,50,1,1);
*/

--Select * FROM matches
--SELECT * FROM players

WITH player_score AS
(
	SELECT	
		first_player AS player_id,
		first_score AS score
	FROM matches
	UNION ALL
	SELECT	
		second_player AS player_id,
		second_score AS score
	FROM matches
),
player_score_consolidated AS 
(
	SELECT 
		player_id,
		SUM(score) AS total_score
	FROM player_score
	GROUP BY player_id
),
group_wise_player_score AS
(	
	SELECT 
		p.group_id,
		ps.player_id,
		ps.total_score,
		RANK() OVER(PARTITION BY p.group_id ORDER BY ps.total_score desc, ps.player_id asc) group_rank
	FROM player_score_consolidated ps
	JOIN players p
	ON ps.player_id = p.player_id
)
SELECT 
	group_id,
	player_id	
FROM group_wise_player_score
WHERE group_rank = 1
		




	