-- A4 - Rewrite WITHOUT GOTO
-- Part 1 rewrites A1 (number classifier) with IF / ELSIF / ELSE.
-- Part 2 rewrites A2 (salary review) with a searched CASE expression.
-- Same outputs as A1 and A2, but the code reads top-to-bottom with no
-- jumping. This is why structured code is preferred over GOTO.
SET SERVEROUTPUT ON;

-- ---------- Part 1: A1 without GOTO ----------------------------------
DECLARE
  v_num NUMBER := -7;
BEGIN
  IF v_num > 0 THEN
    DBMS_OUTPUT.PUT_LINE(v_num || ' is POSITIVE');
  ELSIF v_num < 0 THEN
    DBMS_OUTPUT.PUT_LINE(v_num || ' is NEGATIVE');
  ELSE
    DBMS_OUTPUT.PUT_LINE(v_num || ' is ZERO');
  END IF;

  IF v_num != 0 THEN
    IF MOD(v_num, 2) = 0 THEN
      DBMS_OUTPUT.PUT_LINE(v_num || ' is EVEN');
    ELSE
      DBMS_OUTPUT.PUT_LINE(v_num || ' is ODD');
    END IF;
  END IF;
END;
/

-- ---------- Part 2: A2 without GOTO ----------------------------------
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

  v_band := CASE
              WHEN v_salary IS NULL       THEN 'MISSING'
              WHEN v_salary < 100000      THEN 'LOW'
              WHEN v_salary <= 1000000    THEN 'STANDARD'
              ELSE                             'HIGH'
            END;

  v_pct := CASE v_band
             WHEN 'LOW'      THEN 10
             WHEN 'STANDARD' THEN 5
             WHEN 'HIGH'     THEN 2
             ELSE 0
           END;

  IF v_band = 'MISSING' THEN
    DBMS_OUTPUT.PUT_LINE(v_name || ': no salary on record - cannot review');
  ELSE
    v_new_salary := v_salary + (v_salary * v_pct / 100);
    DBMS_OUTPUT.PUT_LINE('Employee : ' || v_name);
    DBMS_OUTPUT.PUT_LINE('Salary   : ' || v_salary);
    DBMS_OUTPUT.PUT_LINE('Band     : ' || v_band || ' (' || v_pct || '% raise)');
    DBMS_OUTPUT.PUT_LINE('New pay  : ' || v_new_salary);
  END IF;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Employee ' || v_emp_id || ' not found');
END;
/
