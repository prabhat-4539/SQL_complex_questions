/*
create table orders
(
order_id int,
customer_id int,
product_id int,
);

insert into orders VALUES 
(1, 1, 1),
(1, 1, 2),
(1, 1, 3),
(2, 2, 1),
(2, 2, 2),
(2, 2, 4),
(3, 1, 5);

create table products (
id int,
name varchar(10)
);
insert into products VALUES 
(1, 'A'),
(2, 'B'),
(3, 'C'),
(4, 'D'),
(5, 'E');
*/

--SELECT * FROM orders
--SELECT * FROM products
WITH customer_product_pair AS
(
	SELECT
		o1.order_id,
		p1.name + p2.name AS product_pair
	FROM orders o1
	JOIN orders o2
	ON o1.order_id = o2.order_id and o1.product_id != o2.product_id	
	JOIN products p1
	ON p1.id = o1.product_id
	JOIN products p2
	ON p2.id = o2.product_id
	WHERE o2.product_id > o1.product_id
	
)
SELECT product_pair,
	COUNT(*) AS pair_frequesncy
FROM customer_product_pair
GROUP BY product_pair
