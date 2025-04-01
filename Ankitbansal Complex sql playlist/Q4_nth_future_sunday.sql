-- Write a query to provide the date for nth occurrence	of Sunday in future from given date.

DECLARE @todays_date date = GETDATE(), @n int = 3, @given_date date = '2025-02-15'
SELECT 
	DATEPART(WEEKDAY, @todays_date) Todays_weekday,
	DATEADD(day,1-DATEPART(WEEKDAY, @todays_date),@todays_date) Last_sunday_date,
	DATEADD(day,@n * 7,DATEADD(day,1-DATEPART(WEEKDAY, @todays_date),@todays_date)) nth_future_sunday_date

SELECT
	DATEPART(WEEKDAY, @given_date) given_date_weekday,
	DATEADD(day,1-DATEPART(WEEKDAY, @given_date),@given_date) Last_sunday,
	DATEADD(day,@n * 7,DATEADD(day,1-DATEPART(WEEKDAY, @given_date),@given_date)) nth_future_sunday
	
	

