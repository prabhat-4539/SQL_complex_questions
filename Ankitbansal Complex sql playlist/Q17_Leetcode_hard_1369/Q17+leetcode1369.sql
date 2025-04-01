/* 
create table UserActivity
(
username      varchar(20) ,
activity      varchar(20),
startDate     Date   ,
endDate      Date
);

insert into UserActivity values 
('Alice','Travel','2020-02-12','2020-02-20')
,('Alice','Dancing','2020-02-21','2020-02-23')
,('Alice','Travel','2020-02-24','2020-02-28')
,('Bob','Travel','2020-02-11','2020-02-18');
*/
WITH activity_detail AS 
(
	SELECT 
		username,
		activity,
		startDate,
		endDate,
		RANK() OVER (PARTITION BY username ORDER BY endDate DESC) AS date_rn,
		COUNT(username) OVER(PARTITION BY username ) AS total_activity
	FROM UserActivity 
)
SELECT 
	username,
	activity,
	startDate,
	endDate
FROM activity_detail
WHERE (total_activity = 1) OR (total_activity >1 and date_rn =2) 

