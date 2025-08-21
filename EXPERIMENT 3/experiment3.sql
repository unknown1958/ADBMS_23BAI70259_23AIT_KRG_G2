CREATE DATABASE EXPERIMENT3;

-- Create Department Table
CREATE TABLE department (
    id INT PRIMARY KEY,
    dept_name VARCHAR(50)
);

-- Create Employee Table
CREATE TABLE employee (
    id INT,
    name VARCHAR(50),
    salary INT,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES department(id)
);

-- Insert Departments
INSERT INTO department (id, dept_name) VALUES
(1, 'IT'),
(2, 'SALES');

-- Insert Employees
INSERT INTO employee (id, name, salary, department_id) VALUES
(1, 'JOE', 70000, 1),
(2, 'JIM', 90000, 1),
(3, 'HENRY', 80000, 2),
(4, 'SAM', 60000, 2),
(5, 'MAX', 90000, 1);

-- Display Data
SELECT * FROM employee;
SELECT * FROM department;

-- Query: Highest salary in each department
SELECT D.DEPT_NAME, E.NAME, E.salary
FROM employee AS E
INNER JOIN department AS D
    ON D.ID = E.department_id
WHERE salary IN (
    SELECT MAX(salary)
    FROM employee AS E2
    WHERE E2.department_id = E.department_id
)
ORDER BY D.DEPT_NAME;



-- Create Table A
CREATE TABLE A (
    EMPID INT PRIMARY KEY,
    ENAME VARCHAR(MAX),
    SALARY INT
);

-- Create Table B
CREATE TABLE B (
    EMPID INT PRIMARY KEY,
    ENAME VARCHAR(MAX),
    SALARY INT
);

-- Insert into A
INSERT INTO A VALUES (1, 'AA', 5000), (2, 'BB', 3000);

-- Insert into B
INSERT INTO B VALUES (2, 'BB', 7000), (3, 'CC', 4000);

-- Display Tables
SELECT * FROM A;
SELECT * FROM B;

-- Query: Merge A and B, choose MIN values per EMPID
SELECT EMPID,
       MIN(ENAME) AS ENAME,
       MIN(SALARY) AS SALARY
FROM (
    SELECT * FROM A
    UNION ALL
    SELECT * FROM B
) AS INTERMEDIATE_RESULT
GROUP BY EMPID;
