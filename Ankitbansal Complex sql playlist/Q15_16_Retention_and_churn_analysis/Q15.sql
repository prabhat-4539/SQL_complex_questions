/*
create table transactions(
order_id int,
cust_id int,
order_date date,
amount int
);
delete from transactions;
insert into transactions values 
(1,1,'2020-01-15',150)
,(2,1,'2020-02-10',150)
,(3,2,'2020-01-16',150)
,(4,2,'2020-02-25',150)
,(5,3,'2020-01-10',150)
,(6,3,'2020-02-20',150)
,(7,4,'2020-01-20',150)
,(8,5,'2020-02-20',150)
*/

WITH transactions_2month AS
(
	SELECT
		t1.cust_id,
		t1.order_date,
		t2.cust_id AS previous_month_customer,
		t2.order_date AS previous_month_order_date
	FROM transactions t1
	LEFT JOIN transactions t2
	ON t1.cust_id = t2.cust_id AND DATEDIFF(month, t2.order_date ,t1.order_date) = 1
),
retained_churned AS
(
	SELECT 
		FORMAT(order_date,'MM yyyy') AS month,
		COUNT(DISTINCT cust_id) as total_monthly_customer,
		COALESCE(LAG(COUNT(DISTINCT cust_id)) OVER(ORDER BY FORMAT(order_date,'MM yyyy')),0) AS previous_month_customer,
		COUNT(DISTINCT previous_month_customer) AS retained_customer,
		COALESCE(LAG(COUNT(DISTINCT cust_id)) OVER(ORDER BY FORMAT(order_date,'MM yyyy')),0) - COUNT(DISTINCT previous_month_customer) AS churned_customer
	FROM transactions_2month 
	GROUP BY FORMAT(order_date,'MM yyyy')
)
SELECT 
	month,
	CASE WHEN previous_month_customer = 0 THEN 'NA'
	ELSE CAST(CAST(retained_customer AS FLOAT)*100/previous_month_customer AS VARCHAR(20)) + '%' END AS retention_rate,
	CASE WHEN previous_month_customer = 0 THEN 'NA'
	ELSE CAST(CAST(churned_customer AS FLOAT)*100/previous_month_customer AS VARCHAR(20)) + '%' END AS churned_customer_rate
FROM retained_churned


	
