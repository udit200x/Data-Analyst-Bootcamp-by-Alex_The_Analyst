DELIMITER $$
CREATE PROCEDURE large_salaries2()
BEGIN
	SELECT *
	FROM Parks_and_Recreation.employee_salary
	WHERE salary >=50000;
	SELECT *
	FROM Parks_and_Recreation.employee_salary
	WHERE salary >=100000;
END $$
DELIMITER ;


##TRIGGERS AND EVENTS

SELECT *
FROM employee_demographics;

select *
FROM employee_salary;

DELIMITER $$
CREATE TRIGGER employee_insert
	AFTER INSERT ON employee_salary
    FOR EACH ROW 
BEGIN
	INSERT INTO employee_demographics(employee_id,first_name,last_name)
    VALUES(NEW.employee_id,NEW.first_name,NEW.last_name)
END
DELIMITER ;

INSERT INTO employee_salary (employee_id,first_name,last_name,occupation,salary,dept_id)
VALUES(13,'Sam','Altman','OpenAI-CEO',10000,NULL);


##EVENTS

SELECT *
FROM employee_demographics;

DELIMITER $$
CREATE EVENT delete_retirees
ON SCHEDULE EVERY 30 SECOND
DO
BEGIN
	DELETE
    FROM employee_demographics
    WHERE age>=60;
END
DELIMITER $$

SHOW VARIABLES LIKE 'event%';