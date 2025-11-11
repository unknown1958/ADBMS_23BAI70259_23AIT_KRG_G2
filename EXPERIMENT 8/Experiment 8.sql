------------------------------Experiment 08-------------------------------
---------------------Hard Level Problem-----------------------------
/*
Design a robust PostgreSQL transaction system for the students table where multiple student records are inserted in a single transaction. 
If any insert fails due to invalid data, only that insert should be rolled back while preserving the previous successful inserts using savepoints. 
The system should provide clear messages for both successful and failed insertions, ensuring data integrity and controlled error handling.
*/

DROP TABLE IF EXISTS students;

CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    age INT,
    class INT
);

DO $$
BEGIN
    BEGIN
        INSERT INTO students(name, age, class) VALUES ('Supriya',16,8);
        INSERT INTO students(name, age, class) VALUES ('Rakshit',17,8);
        INSERT INTO students(name, age, class) VALUES ('Varun',19,9);

        RAISE NOTICE 'Transaction Successfully Done';

    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Transaction Failed..! Rolling back changes.';
            RAISE;  
    END;
END;
$$;

SELECT * FROM students;

----------------------------------WRONG DATA TYPE SCENARIO----------------------------------
BEGIN;  -- start transaction

SAVEPOINT sp1;
INSERT INTO students(name, age, class) VALUES ('Aarav',16,8);

SAVEPOINT sp2;
BEGIN
    INSERT INTO students(name, age, class) VALUES ('Rahul','wrong',9);  -- fails
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Failed to insert Rahul, rolling back to savepoint sp2';
    ROLLBACK TO SAVEPOINT sp2;
END;

-- Next insert
INSERT INTO students(name, age, class) VALUES ('Sita',17,10);

COMMIT;  -- commit all successful inserts
