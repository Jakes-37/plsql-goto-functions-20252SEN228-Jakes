-- B5 - Using the functions inside SQL
-- The WHERE clause skips rows that would make B1/B2/B3 raise errors
-- (negative salary, future hire date); the validator (C1) is what
-- reports those rows.
SET LINESIZE 200
SET PAGESIZE 50
COLUMN emp_name      FORMAT A18
COLUMN department    FORMAT A18

-- Query 1: functions in the SELECT list
SELECT e.emp_id,
       e.emp_name,
       e.monthly_salary,
       fn_annual_salary(e.monthly_salary)   AS annual_salary,
       fn_years_of_service(e.hire_date)     AS years_service,
       fn_calculate_tax(e.monthly_salary)   AS monthly_tax,
       fn_dept_name(e.dept_id)              AS department
FROM   employees e
WHERE  NVL(e.monthly_salary, 0) >= 0
AND    e.hire_date <= SYSDATE
ORDER  BY e.emp_id;

-- Query 2: a function inside the WHERE clause
SELECT e.emp_name, e.monthly_salary, fn_calculate_tax(e.monthly_salary) AS monthly_tax
FROM   employees e
WHERE  NVL(e.monthly_salary, 0) >= 0
AND    fn_calculate_tax(e.monthly_salary) > 10000
ORDER  BY monthly_tax DESC;
