/*CREATE TABLE cricket_match
( Team_1 varchar(40),
Team_2 varchar (40),
Winning_Team varchar(40)
)

INSERT INTO cricket_match
(Team_1,Team_2,Winning_Team)
VALUES
('India','SL','India'),
('SL','Aus','Aus'),
('SA', 'Eng', 'Eng'),
('Eng', 'NZ','NZ'),
('Aus','India','India')

*/

--SELECT * 
--FROM cricket_match

/* SOLUTION 1 :using cte, left join, case statement */
/* 
WITH Teams AS
(
	SELECT 
		Team_1 as Team_name
	FROM cricket_match
	UNION ALL
	SELECT 
		Team_2
	FROM cricket_match
),
matches_played_cte AS 
(
	SELECT DISTINCT 
		Team_name,
		COUNT(*) AS Matches_played
	FROM Teams
	GROUP BY Team_name
)
SELECT 
	mp.Team_name,
	mp.Matches_played,
	SUM(CASE WHEN cm.Winning_Team = mp.Team_name THEN 1 else 0 end)  AS matches_won,
	mp.Matches_played - SUM(CASE WHEN cm.Winning_Team = mp.Team_name THEN 1 else 0 end) AS matches_lost
FROM matches_played_cte mp
LEFT JOIN cricket_match cm 
ON mp.Team_name = cm.Winning_Team
GROUP BY mp.Team_name,mp.Matches_played
ORDER BY matches_won desc */

/* SOLUTION 2 : using inner query*/
/* 
SELECT team_name,
	COUNT(team_name) AS matches_played,
	SUM(win_flag) AS matches_won,
	COUNT(team_name) - SUM(win_flag) AS matches_lost
FROM (SELECT Team_1 AS team_name,
	CASE WHEN Team_1 = Winning_Team THEN 1 ELSE 0 end AS win_flag
FROM cricket_match
UNION ALL
SELECT Team_2 AS team_name,
	CASE WHEN Team_2 = Winning_Team THEN 1 ELSE 0 end AS win_flag
FROM cricket_match ) t
GROUP BY team_name */










