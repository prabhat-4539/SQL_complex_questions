/*
CREATE TABLE billings
(
emp_name varchar(50),
bill_date date,
bill_rate int
)
INSERT INTO billings
VALUES
( 'Sachin','1990-01-01',25),
('Sehwag','1989-01-01',15),
('Dhoni','1989-01-01',20),
('Sachin','1991-02-05',30);


CREATE TABLE HoursWorked
(
emp_name varchar(50),
work_date date,
bill_hrs int
);

INSERT INTO HoursWorked
VALUES
('Sachin','1990-07-01',3),
('Sachin','1990-08-01',5),
('Sehwag','1990-07-01',2),
('Sachin','1991-07-01',4);
*/
--SELECT * FROM billings
--SELECT * FROM HoursWorked

With temp_rate_list AS
(
	SELECT 
		emp_name,
		bill_date AS bill_start_date,
		LEAD(bill_date) OVER (PARTITION BY emp_name ORDER BY bill_date) AS bill_end_date_temp,
		bill_rate
	FROM billings
), final_rate_list AS
(
	SELECT 
		emp_name,
		bill_start_date,
		CASE WHEN bill_end_date_temp IS NULL THEN CAST(GETDATE() AS DATE) ELSE DATEADD(day,-1,bill_end_date_temp) END AS bill_end_date,
		bill_rate
	FROM temp_rate_list
), earning_cte AS
(
	SELECT 
		hw.emp_name,
		hw.bill_hrs,
		fr.bill_rate
	FROM final_rate_list fr
	JOIN HoursWorked hw
	ON fr.emp_name = hw.emp_name AND hw.work_date BETWEEN fr.bill_start_date AND fr.bill_end_date
)
SELECT 
	emp_name,
	SUM(bill_hrs*bill_rate) AS total_earnings
FROM earning_cte
GROUP BY emp_name

