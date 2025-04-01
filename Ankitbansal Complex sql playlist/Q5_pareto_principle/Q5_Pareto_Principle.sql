/* Pareto principle:
It states that 80% of the consequences come from 20% of the causes.
- 80% of productivity comes from 20% employees.
-80% of sales come from 20% 20% product.
-80% products purchased by 20% of customers.
*/
--SELECT * FROM Orders
DECLARE @sum_total_sales float;
SELECT @sum_total_sales = SUM(Sales) FROM Orders;

WITH product_sales AS
(
	SELECT 
		Product_Name,
		SUM(Sales) as total_sales
	FROM Orders
	GROUP BY Product_Name
),
sales_percent AS
(
SELECT 
	Product_Name,
	total_sales,
	SUM(total_sales) OVER( ORDER BY total_sales desc ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) AS sales_running_sum,
	(SUM(total_sales) OVER( ORDER BY total_sales desc ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ))*100.00/@sum_total_sales  percent_sales
FROM product_sales
)
SELECT TOP 20 PERCENT *
FROM sales_percent ----TOP 20% products contribute to around 77% sales. Hence Preto principle is quite valid.
	