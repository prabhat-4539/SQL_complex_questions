/*SELECT TOP 6 * FROM emp
ORDER BY salary;

SELECT * FROM emp
ORDER BY salary
OFFSET 3 ROWS
FETCH NEXT 3 ROWS ONLY
*/
---Finding duplicates
/*SELECT * FROM emp
ORDER BY salary

SELECT salary,
	COUNT(*) AS salary_count
FROM emp
GROUP BY salary
HAVING count(*) > 1*/
--Deleting Duplicates
/*WITH delete_cte AS
(
SELECT 
	*,
	ROW_NUMBER() OVER(PARTITION BY salary ORDER BY salary) AS rn	
FROM emp
)
DELETE FROM delete_cte 
WHERE rn>1
SELECT * FROM emp*/

-- To create copy of a column
/*CREATE TABLE emp1
(emp_id int ,
emp_name varchar(50),
department_id int,
salary int,
manager_id int, 
emp_age int);
INSERT INTO emp1 
SELECT * FROM emp*/

---update using CTE
/*WITH update_cte AS
(
SELECT *,
RANK() OVER (order by salary desc) rn
FROM emp1
)
update update_cte
SET department_id = department_id + 1
WHERE department_id > 200 and rn> 5
select * from emp1*/


--SELECT *, FORMAT(order_date ,'yyyy   MM    d  dd  dddd   ddd  ') from customer_orders

--- Number of rows after different joins
/*SELECT * from t1
SELECT * from t2
SELECT * 
from t1
full join t2
on t1.id = t2.id*/
