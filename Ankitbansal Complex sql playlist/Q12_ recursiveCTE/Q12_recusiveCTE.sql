/* Year wise sales of each product.

create table sales (
product_id int,
period_start date,
period_end date,
average_daily_sales int
);

insert into sales values(1,'2019-01-25','2019-02-28',100),(2,'2018-12-01','2020-01-01',10),(3,'2019-12-01','2020-01-31',1);
*/
--SELECT * FROM sales
/*
WITH daily_sales_1 AS
(
	SELECT 1 AS product_id, CAST('2019-01-25' AS date) AS current_date_,DATEPART(year,'2019-01-25') AS year, 100 AS daily_sale
	UNION ALL
	SELECT 1 AS product_id,DATEADD(day,1,current_date_) AS current_date_,DATEPART(year,DATEADD(day,1,current_date_)) AS year,100 AS daily_sale
	FROM daily_sales_1
	WHERE current_date_ < '2019-02-28' 
),
daily_sales_2 AS
(
	SELECT 2 AS product_id, CAST('2018-12-01' AS date) AS current_date_,DATEPART(year,'2018-12-01') AS year, 10 AS daily_sale
	UNION ALL
	SELECT 2 AS product_id,DATEADD(day,1,current_date_) AS current_date_,DATEPART(year,DATEADD(day,1,current_date_)) AS year,10 AS daily_sale
	FROM daily_sales_2
	WHERE current_date_ < '2020-01-01' 
),
daily_sales_3 AS
(
	SELECT 3 AS product_id, CAST('2019-12-01' AS date) AS current_date_,DATEPART(year,'2019-12-01') AS year, 1 AS daily_sale
	UNION ALL
	SELECT 3 AS product_id,DATEADD(day,1,current_date_) AS current_date_,DATEPART(year,DATEADD(day,1,current_date_)) AS year,1 AS daily_sale
	FROM daily_sales_3
	WHERE current_date_ < '2020-01-31' 
),
consolidated_sales_data AS
(
SELECT 
	product_id,
	current_date_,
	year,
	daily_sale
FROM daily_sales_1
UNION 
SELECT 
	product_id,
	current_date_,
	year,
	daily_sale
FROM daily_sales_2
UNION 
SELECT 
	product_id,
	current_date_,
	year,
	daily_sale
FROM daily_sales_3
)
SELECT product_id,
	year,
	SUM(daily_sale) AS total_sales
FROM consolidated_sales_data
GROUP BY product_id, year
ORDER BY product_id, year
OPTION(MAXRECURSION 32000)
*/


WITH r_cte AS
( 
SELECT 
	min(period_start) as dates, 
	max(period_end) as end_date
FROM sales
UNION ALL
SELECT DATEADD(day,1,dates) AS dates, end_date
FROM r_cte
WHERE dates < end_date
)
SELECT DATEPART(year,r.dates) AS year,
	s.product_id,
	SUM(s.average_daily_sales) AS total_sales
FROM r_cte r
INNER JOIN sales s
ON r.dates between s.period_start and s.period_end
GROUP BY DATEPART(year,r.dates),s.product_id
OPTION (MAXRECURSION 1000)


	
	

