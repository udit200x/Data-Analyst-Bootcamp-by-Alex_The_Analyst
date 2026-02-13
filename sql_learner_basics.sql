#DEFAULT SQL Syntax
SELECT *
FROM Parks_and_Recreation.employee_demographics;

#Inclusion of different parameters to be print (SELECT, SELECT DISTINCT - Only prints the unique values)
SELECT first_name, 
last_name, 
birth_date, 
age, 
(age + 10) * 10
FROM Parks_and_Recreation.employee_demographics;

##GREATER THAN
SELECT *
FROM Parks_and_Recreation.employee_salary
WHERE salary < 50000
;
##PEMDAS LOGIC (P= Parenthesis, E=exponents, M= multiplication, D=division, A = addition, S=subtraction)
SELECT *
FROM Parks_and_Recreation.employee_demographics
WHERE (first_name='Leslie' AND age =44)  ##PEMDAS applies here too
OR age > 55
;

## Percentage sign is like a filler, space can be used to ask for more info regarding characters,
SELECT *
FROM Parks_and_Recreation.employee_demographics
WHERE first_name LIKE'a___%' ## % sign is like a filler
;
#LIKE STATEMENT CAN BE USED TO FIND ALIKE DATA, WITH THE UTILITY OF % AND SPACES
SELECT *
FROM Parks_and_Recreation.employee_demographics
WHERE birth_date LIKE'1989%'
;

#GROUP BY AND ORDER BY
SELECT gender,MAX(age),AVG(age) #aggregate functions
FROM Parks_and_Recreation.employee_demographics
group by GENDER
;
#ORDER BY ARRANGES THE DATA
SELECT *
FROM Parks_and_Recreation.employee_demographics
ORDER BY 4 DESC
;

##HAVING AND WHERE
SELECT first_name, AVG(age)
FROM Parks_and_Recreation.employee_demographics
GROUP BY first_name
HAVING AVG(age) > 40
;

select occupation, avg(salary)
from Parks_and_Recreation.employee_salary
where occupation like '%e manager%'
group by occupation
having avg(salary) > 40000
;

##LIMIT AND ALIASING
SELECT *
FROM Parks_and_Recreation.employee_demographics
ORDER BY age ASC
LIMIT 3
;

##ALIASING
SELECT occupation, MAX(salary) as max_salary
FROM Parks_and_Recreation.employee_salary
GROUP BY occupation
HAVING max_salary > 70000
;
