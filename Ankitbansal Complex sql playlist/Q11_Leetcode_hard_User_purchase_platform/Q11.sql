/* Q11    User purchase platform.
-- The table logs the spendings history of users that make purchases from an online shopping website which has a desktop 
and a mobile application.
-- Write an SQL query to find the total number of users and the total amount spent using mobile only, desktop only 
and both mobile and desktop together for each date.


create table spending 
(
user_id int,
spend_date date,
platform varchar(10),
amount int
);

insert into spending values(1,'2019-07-01','mobile',100),(1,'2019-07-01','desktop',100),(2,'2019-07-01','mobile',100)
,(2,'2019-07-02','mobile',100),(3,'2019-07-01','desktop',100),(3,'2019-07-02','desktop',100);
*/

/*SELECT 
	spend_date,
	COUNT(distinct user_id) AS user_count,
	SUM(CASE WHEN platform ='mobile' THEN amount END) AS mobile_only,
	SUM(CASE WHEN platform ='desktop' THEN amount END) AS desktop_only,
	SUM(amount) as mobile_desktop_combined
FROM spending
GROUP BY spend_date */
WITH single_both_spending AS
(
	SELECT 
		user_id,
		spend_date,
		platform ,
		amount,
		CASE WHEN COUNT(user_id) OVER(partition by spend_date, user_id order by spend_date ) = 1 THEN 'single platform'
			WHEN COUNT(user_id) OVER(partition by spend_date, user_id order by spend_date ) = 2 THEN 'both platform' END AS both_flag
	FROM spending
),
final_data AS
(
SELECT 
	spend_date,
	'both' AS platform,
	COUNT(distinct user_id) AS total_users,
	SUM(amount) AS total_amount
FROM single_both_spending
WHERE both_flag = 'both platform'
GROUP BY spend_date
UNION ALL
SELECT spend_date,
		platform ,
		COUNT(user_id) AS total_users,
		SUM(amount) AS total_amount
FROM single_both_spending
WHERE both_flag = 'single platform'
GROUP BY spend_date, platform
)
,platform_format AS
(
SELECT distinct spend_date,
	'mobile' AS platform
from spending
UNION
SELECT distinct spend_date,
	'desktop' AS platform
from spending
UNION
SELECT distinct spend_date,
	'both' AS platform
from spending
)
SELECT 
	pf.spend_date,
	pf.platform,
	COALESCE(f.total_amount,0),
	COALESCE(f.total_users,0)
FROM platform_format pf
LEFT JOIN final_data f
ON pf.spend_date = f.spend_date and pf.platform = f.platform	
ORDER BY spend_date, platform desc