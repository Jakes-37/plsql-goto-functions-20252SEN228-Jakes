-- C1 - fn_validate_payroll   (combines GOTO + functions + exceptions)
-- Input : employee id
-- Output: 'VALID - ...' with annual salary / tax / years of service,
--         or 'INVALID: <reason>'.
-- Returns VARCHAR2 (not BOOLEAN) so it can also be called from SQL.
-- On the first failed check we set the message and GOTO lbl_done, so the
-- remaining checks and the calculations are skipped.
-- Requires B1-B4 to be created first.
CREATE OR REPLACE FUNCTION fn_validate_payroll (
  p_emp_id IN NUMBER
) RETURN VARCHAR2
IS
  v_emp     employees%ROWTYPE;
  v_result  VARCHAR2(200);
BEGIN
  SELECT *
  INTO   v_emp
  FROM   employees
  WHERE  emp_id = p_emp_id;

  IF v_emp.monthly_salary IS NULL THEN
    v_result := 'INVALID: Salary is missing';
    GOTO lbl_done;
  END IF;

  IF v_emp.monthly_salary < 0 THEN
    v_result := 'INVALID: Salary is negative';
    GOTO lbl_done;
  END IF;

  IF v_emp.dept_id IS NULL THEN
    v_result := 'INVALID: No department assigned';
    GOTO lbl_done;
  END IF;

  IF fn_dept_name(v_emp.dept_id) = 'Unknown Department' THEN
    v_result := 'INVALID: Department does not exist';
    GOTO lbl_done;
  END IF;

  IF v_emp.hire_date IS NULL OR v_emp.hire_date > SYSDATE THEN
    v_result := 'INVALID: Hire date is missing or in the future';
    GOTO lbl_done;
  END IF;

  -- All checks passed
  v_result := 'VALID - Annual: '
              || TO_CHAR(fn_annual_salary(v_emp.monthly_salary), 'FM999,999,999,990')
              || ', Monthly tax: '
              || TO_CHAR(fn_calculate_tax(v_emp.monthly_salary), 'FM999,999,990.00')
              || ', Years of service: '
              || fn_years_of_service(v_emp.hire_date);

  <<lbl_done>>
  RETURN v_result;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN 'INVALID: Employee ' || p_emp_id || ' not found';
END fn_validate_payroll;
/
SHOW ERRORS
