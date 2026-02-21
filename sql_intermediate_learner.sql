##JOINS

SELECT *
FROM Parks_and_Recreation.employee_demographics
;

SELECT dem.employee_id, age, occupation ##ALIASING MAKES IT EASIER TO DISTINGUISH, EXEMPTS AMBIGUOSNESS
FROM Parks_and_Recreation.employee_salary AS sal
INNER JOIN Parks_and_Recreation.employee_demographics AS dem 
 ON dem.employee_id = sal.employee_id ##CRITERIA FOR THE JOIN
 ;
 
 ##OUTER JOIN
SELECT * 
FROM Parks_and_Recreation.employee_salary AS sal
LEFT JOIN Parks_and_Recreation.employee_demographics AS dem 
 ON dem.employee_id = sal.employee_id ##CRITERIA FOR THE JOIN
 ;
 
##SELF JOIN
SELECT emp1.employee_id as emp_santa,
emp1.first_name as first_name_santa,
emp1.last_name as last_name_santa,
emp2.employee_id as emp_santa,
emp2.first_name as first_name_santa,
emp2.last_name as last_name_santa 
FROM Parks_and_Recreation.employee_salary as emp1
JOIN Parks_and_Recreation.employee_salary as emp2
	ON emp1.employee_id + 1 = emp2.employee_id
;
 
 ##Joining multiple tables together
 
SELECT * ##ALIASING MAKES IT EASIER TO DISTINGUISH, EXEMPTS AMBIGUOSNESS
FROM Parks_and_Recreation.employee_salary AS sal
INNER JOIN Parks_and_Recreation.employee_demographics AS dem 
 ON sal.employee_id = dem.employee_id ##CRITERIA FOR THE JOIN
INNER JOIN Parks_and_Recreation.parks_departments as pd
	ON sal.dept_id = pd.department_id
 ;

##Unions (Like in Set Theory)

SELECT first_name, last_name
FROM Parks_and_Recreation.employee_demographics
UNION ALL
SELECT first_name, last_name
FROM Parks_and_Recreation.employee_salary
;

SELECT first_name, last_name, 'old man' as label
FROM Parks_and_Recreation.employee_demographics
WHERE age > 40 and gender = 'male'
UNION
SELECT first_name, last_name, 'old lady' as label
FROM Parks_and_Recreation.employee_demographics
WHERE age > 40 and gender = 'female'
UNION
SELECT first_name, last_name, 'Highly paid employee' as label
FROM Parks_and_Recreation.employee_salary
WHERE salary > 70000
ORDER BY first_name, last_name
;

##STRING FUNCTIONS

SELECT first_name, LENGTH(first_name)
FROM Parks_and_Recreation.employee_demographics
ORDER BY 2
;	

SELECT first_name, UPPER(first_name)
FROM Parks_and_Recreation.employee_demographics
ORDER BY 2
;	
SELECT first_name, 
LEFT(first_name,4),
right(first_name,4),
substring(birth_date,6,2) as birth_month
FROM Parks_and_Recreation.employee_demographics
;

SELECT first_name, REPLACE(first_name, 'a','z')
FROM Parks_and_Recreation.employee_demographics;

SELECT first_name, LOCATE('An',first_name)
FROM Parks_and_Recreation.employee_demographics;

SELECT first_name,last_name,
CONCAT(first_name,' ',last_name)
FROM Parks_and_Recreation.employee_demographics;

#CASE STATEMENTS

SELECT first_name,
last_name,
CASE
	WHEN age <=30 THEN 'Young'
    WHEN age BETWEEN 31 and 50 THEN 'Old'
    WHEN age >=50 THEN "On Death's Door"
END as Age_bracket
FROM Parks_and_Recreation.employee_demographics;

SELECT first_name,last_name,salary,
CASE
	WHEN salary < 50000 THEN '5%'
    WHEN salary > 50000 THEN '7%'
END as Hike_Percent
FROM Parks_and_Recreation.employee_salary
;

##SUBQUERIES are almost like creating mini tables for easy access.

SELECT * 
FROM Parks_and_Recreation.employee_demographics;

SELECT *
FROM Parks_and_Recreation.employee_salary;

#USING WHERE CLAUSE

SELECT *
FROM Parks_and_Recreation.employee_demographics
WHERE employee_id IN 
				(SELECT employee_id
					FROM Parks_and_Recreation.employee_salary
                    WHERE dept_id = 1)
;

SELECT first_name, salary,
(SELECT AVG(salary)
FROM Parks_and_Recreation.employee_salary)
FROM Parks_and_Recreation.employee_salary;

SELECT AVG( 'MAX(age)')
FROM 
(SELECT gender, AVG(age), MAX(age), MIN(age), COUNT(age)
FROM Parks_and_Recreation.employee_demographics
GROUP BY gender) AS Agg_Table;

##WINDOW FUNCTIONS

SELECT gender, AVG(salary) as avg_salary 
FROM Parks_and_Recreation.employee_demographics dem
JOIN Parks_and_Recreation.employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender;


SELECT dem.first_name,dem.last_name,gender,salary,
sum(salary) OVER(PARTITION BY gender ORDER BY dem.employee_id) AS Rolling_Total ##OVER the entire column, PARTITION Is equivalent of GROUP BY.
FROM Parks_and_Recreation.employee_demographics dem
JOIN Parks_and_Recreation.employee_salary sal
	ON dem.employee_id = sal.employee_id
;

SELECT dem.first_name,dem.last_name,gender,salary,
ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary desc) as row_num,
RANK() OVER(PARTITION BY gender ORDER BY salary desc) AS rank_num,
DENSE_RANK()OVER(PARTITION BY gender ORDER BY salary desc) AS dense_rank_num
FROM Parks_and_Recreation.employee_demographics dem
JOIN Parks_and_Recreation.employee_salary sal
	ON dem.employee_id = sal.employee_id;
