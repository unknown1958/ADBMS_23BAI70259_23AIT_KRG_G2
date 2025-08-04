--Medium Level Problem
CREATE TABLE Employee (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(50) NOT NULL,
    Department VARCHAR(50) NOT NULL,
    ManagerID INT NULL  
);

ALTER TABLE Employee
ADD CONSTRAINT FK_EMPLOYEE FOREIGN KEY (ManagerID) REFERENCES EMPLOYEE(EmpID)

INSERT INTO Employee (EmpID, EmpName, Department, ManagerID)
VALUES
(1, 'Alice', 'HR', NULL),        
(2, 'Bob', 'Finance', 1),
(3, 'Charlie', 'IT', 1),
(4, 'David', 'Finance', 2),
(5, 'Eve', 'IT', 3),
(6, 'Frank', 'HR', 1);

SELECT E1.EmpName as [EMPLOYEE NAME], E2.EmpName as [Manager Name],
E1.Department as [Employee Dept], E2.ManagerId as [Manager ID]
FROM Employee as E1
LEFT OUTER JOIN
Employee as E2 
ON 
E1.ManagerID = E2.EmpID

--HARD LEVEL PROBLEM
CREATE TABLE Year_tbl (
    ID INT,
    YEAR INT,
    NPV INT
);

-- Create Queries table (requested values)
CREATE TABLE Queries (
    ID INT,
    YEAR INT
);

-- Insert data into Year_tbl
INSERT INTO Year_tbl (ID, YEAR, NPV)
VALUES
(1, 2018, 100),
(7, 2020, 30),
(13, 2019, 40),
(1, 2019, 113),
(2, 2008, 121),
(3, 2009, 12),
(11, 2020, 99),
(7, 2019, 0);

-- Insert data into Queries
INSERT INTO Queries (ID, YEAR)
VALUES
(1, 2019),
(2, 2008),
(3, 2009),
(7, 2018),
(7, 2019),
(7, 2020),
(13, 2019);

SELECT Q.ID  AS [ID], Q.YEAR AS [YEAR] , ISNULL(Y.NPV,0) AS [NPV]
FROM Queries AS Q
LEFT OUTER JOIN
Year_tbl AS Y
ON
Q.YEAR = Y.YEAR
AND 
Q.ID = Y.ID