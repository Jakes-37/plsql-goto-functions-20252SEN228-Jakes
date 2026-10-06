-- =====================================================================
-- 00_setup/create_tables.sql
-- Creates the DEPARTMENTS and EMPLOYEES tables with sample data.
-- monthly_salary is a MONTHLY amount (RWF). Some rows are deliberately
-- "bad" (NULL / negative salary, future hire date, no department) so
-- the validator in C1 has something to catch.
-- Safe to re-run: it drops the tables first.
-- =====================================================================
SET SERVEROUTPUT ON;

BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE employees PURGE';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN RAISE; END IF;   -- -942 = table does not exist
END;
/

BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE departments PURGE';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

CREATE TABLE departments (
  dept_id    NUMBER(4)    PRIMARY KEY,
  dept_name  VARCHAR2(50) NOT NULL
);

CREATE TABLE employees (
  emp_id          NUMBER(6)    PRIMARY KEY,
  emp_name        VARCHAR2(80) NOT NULL,
  monthly_salary  NUMBER(12,2),
  hire_date       DATE,
  dept_id         NUMBER(4),
  CONSTRAINT fk_emp_dept FOREIGN KEY (dept_id) REFERENCES departments (dept_id)
);

INSERT INTO departments VALUES (10, 'Finance');
INSERT INTO departments VALUES (20, 'IT');
INSERT INTO departments VALUES (30, 'Human Resources');

-- Good records
INSERT INTO employees VALUES (1, 'Alice Uwase',     450000,  DATE '2018-03-15', 10);
INSERT INTO employees VALUES (2, 'Eric Habimana',  1200000,  DATE '2015-07-01', 20);
INSERT INTO employees VALUES (3, 'Grace Mukamana',   80000,  DATE '2022-01-10', 10);
INSERT INTO employees VALUES (4, 'Jean Bosco',     2500000,  DATE '2010-11-20', 30);
-- Bad records (used to test validation)
INSERT INTO employees VALUES (5, 'Diane Ingabire',     NULL, DATE '2023-05-05', 20);  -- missing salary
INSERT INTO employees VALUES (6, 'Patrick Nshuti',    -5000, DATE '2021-09-09', 10);  -- negative salary
INSERT INTO employees VALUES (7, 'Sandra Uwimana',   600000, DATE '2030-01-01', 10);  -- hire date in future
INSERT INTO employees VALUES (8, 'Kevin Mugisha',    300000, DATE '2020-02-02', NULL);-- no department

COMMIT;

SELECT * FROM departments;
SELECT * FROM employees ORDER BY emp_id;
