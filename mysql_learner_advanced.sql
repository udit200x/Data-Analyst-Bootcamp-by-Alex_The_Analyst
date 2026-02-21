WITH CTE_Example AS ##Comment Table Expression as CTE
(
SELECT gender, AVG(salary) avg_sal, MAX(salary) max_sal, MIN(salary), COUNT(salary)
FROM Parks_and_Recreation.employee_demographics dem
JOIN Parks_and_Recreation.employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
)
SELECT max_sal
FROM CTE_Example
;



WITH CTE_Example AS ##Comment Table Expression as CTE - you can overwrite column names in the paranthesis ()
(
SELECT employee_id,gender,birth_date
FROM Parks_and_Recreation.employee_demographics dem
WHERE birth_date > '1985-01-01'
),
CTE_Example2 AS
(
SELECT employee_id, salary
FROM Parks_and_Recreation.employee_salary
WHERE salary > 50000
)
SELECT *
FROM CTE_Example
JOIN CTE_Example2
	ON CTE_Example.employee_id = CTE_Example2.employee_id
;


##TEMPORARY TABLES

CREATE TEMPORARY TABLE temp_table
(first_name varchar(50),
last_name varchar(50),
favorite_movie varchar(100)
);

INSERT INTO temp_table
VALUES('Uditangshu','De','Dhurandhar');

SELECT *
FROM temp_table;




