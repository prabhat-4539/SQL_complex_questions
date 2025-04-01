-- Calculating mean, median and mode
-- Q1> You are given marks of students, find mean, median and mode for this ungrouped data.
-- Q2> You are given marks of students,convert it into grouped data with interval width of 10 and then find mean, median and mode for this grouped data.

--CREATE TABLE student_marks
--(marks int)

/*INSERT INTO student_marks
VALUES
(10),(12),(54),(66),(45),(67),(54),(23),(10),(15),(54),(32),(12),(98),(76),(65),(76),(87),
(10),(10),(10),(10),(94),(15),(62),(73),(84),(73),(62),(15),(27),(86),(76),(65),(32),(77),
(65),(55),(76),(78)*/

WITH ungrouped_marks AS
(
	SELECT 
		marks, 
		COUNT(marks) AS frequency
	FROM student_marks
	GROUP BY marks
), 
marks_frequency_detail AS
(
	SELECT 
		marks,
		frequency,
		marks * frequency AS mf,
		SUM(frequency) OVER (ORDER BY marks ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_frequency
	FROM ungrouped_marks
)
SELECT 
	--ROUND(CAST(SUM(mf) AS decimal(10,2))/CAST(MAX(cumulative_frequency) AS  decimal(10,2)),2) AS mean,
	*

FROM marks_frequency_detail
	