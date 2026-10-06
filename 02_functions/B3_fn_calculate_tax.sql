-- =====================================================================
-- B3 - fn_calculate_tax  (monthly tax on a monthly salary)
-- Progressive (marginal) brackets - a SIMPLIFIED model based on
-- Rwanda's PAYE bands. If your instructor gave different brackets,
-- change the numbers below.
--     0 -  60,000  ->  0%
--  60,001 - 100,000 -> 20% (only on the part above 60,000)
--  above 100,000    -> 30% (only on the part above 100,000)
-- Worked example: 200,000 -> 40,000*20% + 100,000*30% = 8,000 + 30,000 = 38,000
-- NULL in -> NULL out.  Negative in -> ORA-20003.
-- =====================================================================
CREATE OR REPLACE FUNCTION fn_calculate_tax (
  p_monthly_salary IN NUMBER
) RETURN NUMBER
IS
  v_tax NUMBER;
BEGIN
  IF p_monthly_salary IS NULL THEN
    RETURN NULL;
  END IF;

  IF p_monthly_salary < 0 THEN
    RAISE_APPLICATION_ERROR(-20003, 'Monthly salary cannot be negative');
  END IF;

  IF p_monthly_salary <= 60000 THEN
    v_tax := 0;
  ELSIF p_monthly_salary <= 100000 THEN
    v_tax := (p_monthly_salary - 60000) * 0.20;
  ELSE
    v_tax := (100000 - 60000) * 0.20 + (p_monthly_salary - 100000) * 0.30;
  END IF;

  RETURN ROUND(v_tax, 2);
END fn_calculate_tax;
/
SHOW ERRORS
