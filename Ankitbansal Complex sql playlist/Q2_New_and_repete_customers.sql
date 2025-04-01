/*CREATE TABLE customer_orders
(order_id int,
customer_id int,
order_date date,
order_amount int)

insert into customer_orders values(1,100,cast('2022-01-01' as date),2000),(2,200,cast('2022-01-01' as date),2500),(3,300,cast('2022-01-01' as date),2100)
,(4,100,cast('2022-01-02' as date),2000),(5,400,cast('2022-01-02' as date),2200),(6,500,cast('2022-01-02' as date),2700)
,(7,100,cast('2022-01-03' as date),3000),(8,400,cast('2022-01-03' as date),1000),(9,600,cast('2022-01-03' as date),3000)
*/

/* SOLUTION 1

WITH new_customer AS
(
	SELECT 
		t1.order_date,
		COUNT(distinct customer_id) AS new_customer
	FROM customer_orders t1
	WHERE customer_id NOT IN (	SELECT 
									distinct customer_id 
								FROM customer_orders t2 
								WHERE t1.order_date > t2.order_date
								)
	GROUP BY order_date
)
SELECT co.order_date,
	AVG(nc.new_customer),
	(COUNT(distinct co.customer_id)  - AVG(nc.new_customer)) AS repeat_customer
FROM customer_orders co
JOIN new_customer nc
ON co.order_date = nc.order_date
GROUP BY co.order_date
*/

---SOLUTION 2

--SELECT * from customer_orders
/*
WITH first_visit AS
(
SELECT 
	customer_id, 
	MIN(order_date) AS first_visit_date
FROM customer_orders
GROUP BY customer_id
)
SELECT 
	co.order_date,
	SUM(CASE WHEN fv.first_visit_date = co.order_date THEN 1 ELSE 0 END ) AS first_customers,
	SUM(CASE WHEN fv.first_visit_date != co.order_date THEN 1 ELSE 0 END ) AS repete_customers
	--COUNT(*) - SUM(CASE WHEN fv.first_visit_date = co.order_date THEN 1 ELSE 0 END ) AS repete_customers
FROM customer_orders co
JOIN first_visit fv
ON co.customer_id = fv.customer_id
GROUP BY co.order_date
*/


/*Amount by first customer and repete customer*/
WITH first_visit AS
(
SELECT 
	customer_id, 
	MIN(order_date) AS first_visit_date
FROM customer_orders
GROUP BY customer_id
),
customer_status AS
(
	SELECT 
		co.order_date,
		co.order_amount,
		CASE WHEN fv.first_visit_date = co.order_date THEN 'first_customers' ELSE 'repete_customers' END AS customer_visit_status
	FROM customer_orders co
	JOIN first_visit fv
	ON co.customer_id = fv.customer_id
)
SELECT order_date,
	SUM(CASE WHEN customer_visit_status = 'first_customers' THEN order_amount ELSE 0 END ) AS first_customers_amount,
	SUM(CASE WHEN customer_visit_status = 'repete_customers' THEN order_amount ELSE 0 END ) AS repete_customers_amount
FROM customer_status
GROUP BY order_date



