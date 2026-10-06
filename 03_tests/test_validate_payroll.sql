-- test_validate_payroll.sql - tests C1
-- Expected results:
--  1 Jane    VALID - Annual: 5,400,000, Monthly tax: 113,000.00, Years of service: <n>
--  2 Eric     VALID
--  3 Gracious    VALID  (tax 4,000.00)
--  4 John     VALID
--  5 Diane    INVALID: Salary is missing
--  6 Isaac  INVALID: Salary is negative
--  7 Sandrine   INVALID: Hire date is missing or in the future
--  8 Kelvin    INVALID: No department assigned
--  999        INVALID: Employee 999 not found
-- Jane's tax = 8,000 + (500,000-100,000)*30% = 128,000.00
SET SERVEROUTPUT ON;
SET LINESIZE 200
COLUMN emp_name FORMAT A18
COLUMN result   FORMAT A90

SELECT emp_id, emp_name, fn_validate_payroll(emp_id) AS result
FROM   employees
ORDER  BY emp_id;

-- Employee that does not exist
SELECT fn_validate_payroll(999) AS result FROM dual;
