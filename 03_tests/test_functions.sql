-- test_functions.sql - tests B1-B4. Every line should print PASS.
-- Run AFTER create_tables.sql and the four function scripts.
SET SERVEROUTPUT ON;

DECLARE
  v_dummy NUMBER;

  PROCEDURE check_eq (p_name VARCHAR2, p_actual VARCHAR2, p_expected VARCHAR2) IS
  BEGIN
    IF p_actual = p_expected OR (p_actual IS NULL AND p_expected IS NULL) THEN
      DBMS_OUTPUT.PUT_LINE('PASS  ' || p_name);
    ELSE
      DBMS_OUTPUT.PUT_LINE('FAIL  ' || p_name || ' (got ' || p_actual || ', expected ' || p_expected || ')');
    END IF;
  END;
BEGIN
  -- B1
  check_eq('B1 100000 -> 1200000', fn_annual_salary(100000), '1200000');
  check_eq('B1 NULL -> NULL',      fn_annual_salary(NULL),   NULL);
  BEGIN
    v_dummy := fn_annual_salary(-1);
    DBMS_OUTPUT.PUT_LINE('FAIL  B1 negative should raise error');
  EXCEPTION WHEN OTHERS THEN
    check_eq('B1 negative raises -20001', SQLCODE, '-20001');
  END;

  -- B2
  check_eq('B2 hired 66 months ago -> 5', fn_years_of_service(ADD_MONTHS(SYSDATE, -66)), '5');
  check_eq('B2 hired 6 months ago -> 0',  fn_years_of_service(ADD_MONTHS(SYSDATE, -6)),  '0');
  check_eq('B2 NULL -> NULL',             fn_years_of_service(NULL), NULL);
  BEGIN
    v_dummy := fn_years_of_service(SYSDATE + 30);
    DBMS_OUTPUT.PUT_LINE('FAIL  B2 future date should raise error');
  EXCEPTION WHEN OTHERS THEN
    check_eq('B2 future date raises -20002', SQLCODE, '-20002');
  END;

  -- B3
  check_eq('B3 50000  -> 0',     fn_calculate_tax(50000),  '0');
  check_eq('B3 60000  -> 0',     fn_calculate_tax(60000),  '0');
  check_eq('B3 80000  -> 4000',  fn_calculate_tax(80000),  '4000');
  check_eq('B3 100000 -> 8000',  fn_calculate_tax(100000), '8000');
  check_eq('B3 200000 -> 38000', fn_calculate_tax(200000), '38000');
  check_eq('B3 NULL -> NULL',    fn_calculate_tax(NULL),   NULL);
  BEGIN
    v_dummy := fn_calculate_tax(-1);
    DBMS_OUTPUT.PUT_LINE('FAIL  B3 negative should raise error');
  EXCEPTION WHEN OTHERS THEN
    check_eq('B3 negative raises -20003', SQLCODE, '-20003');
  END;

  -- B4
  check_eq('B4 10 -> Finance',            fn_dept_name(10), 'Finance');
  check_eq('B4 20 -> IT',                 fn_dept_name(20), 'IT');
  check_eq('B4 99 -> Unknown Department', fn_dept_name(99), 'Unknown Department');
  check_eq('B4 NULL -> No Department',    fn_dept_name(NULL), 'No Department');
END;
/
