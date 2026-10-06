-- =====================================================================
-- A2 - Salary Review (uses GOTO)
-- Reads one employee's monthly salary and jumps to the matching review
-- band:  < 100,000 LOW (10% raise) | 100,000-1,000,000 STANDARD (5%)
--        > 1,000,000 HIGH (2%)     | NULL -> no review possible
-- Change v_emp_id to test others (5 = NULL salary, 99 = not found).
-- Expected for emp 1 (450,000): STANDARD band, 5% raise, new = 472500
-- =====================================================================
SET SERVEROUTPUT ON;

DECLARE
  v_emp_id      employees.emp_id%TYPE := 1;
  v_name        employees.emp_name%TYPE;
  v_salary      employees.monthly_salary%TYPE;
  v_band        VARCHAR2(10);
  v_pct         NUMBER(5,2);
  v_new_salary  NUMBER(12,2);
BEGIN
  SELECT emp_name, monthly_salary
  INTO   v_name, v_salary
  FROM   employees
  WHERE  emp_id = v_emp_id;

  IF v_salary IS NULL THEN
    GOTO lbl_missing;
  ELSIF v_salary < 100000 THEN
    GOTO lbl_low;
  ELSIF v_salary <= 1000000 THEN
    GOTO lbl_standard;
  ELSE
    GOTO lbl_high;
  END IF;

  <<lbl_low>>
  v_band := 'LOW';       v_pct := 10;
  GOTO lbl_result;

  <<lbl_standard>>
  v_band := 'STANDARD';  v_pct := 5;
  GOTO lbl_result;

  <<lbl_high>>
  v_band := 'HIGH';      v_pct := 2;
  GOTO lbl_result;

  <<lbl_missing>>
  DBMS_OUTPUT.PUT_LINE(v_name || ': no salary on record - cannot review');
  GOTO lbl_end;

  <<lbl_result>>
  v_new_salary := v_salary + (v_salary * v_pct / 100);
  DBMS_OUTPUT.PUT_LINE('Employee : ' || v_name);
  DBMS_OUTPUT.PUT_LINE('Salary   : ' || v_salary);
  DBMS_OUTPUT.PUT_LINE('Band     : ' || v_band || ' (' || v_pct || '% raise)');
  DBMS_OUTPUT.PUT_LINE('New pay  : ' || v_new_salary);

  <<lbl_end>>
  NULL;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Employee ' || v_emp_id || ' not found');
END;
/
