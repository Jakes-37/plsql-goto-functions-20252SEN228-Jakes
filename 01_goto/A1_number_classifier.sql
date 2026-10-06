-- A1 - Number Classifier (uses GOTO)
-- Classifies a number as positive / negative / zero, then (if not zero)
-- as even / odd. Change v_num to test other values.
-- Expected output for -7:  -7 is NEGATIVE   and   -7 is ODD
SET SERVEROUTPUT ON;

DECLARE
  v_num NUMBER := -7;
BEGIN
  -- Step 1: decide which label to jump to
  IF v_num > 0 THEN
    GOTO lbl_positive;
  ELSIF v_num < 0 THEN
    GOTO lbl_negative;
  ELSE
    GOTO lbl_zero;
  END IF;

  <<lbl_positive>>
  DBMS_OUTPUT.PUT_LINE(v_num || ' is POSITIVE');
  GOTO lbl_parity;

  <<lbl_negative>>
  DBMS_OUTPUT.PUT_LINE(v_num || ' is NEGATIVE');
  GOTO lbl_parity;

  <<lbl_zero>>
  DBMS_OUTPUT.PUT_LINE(v_num || ' is ZERO');
  GOTO lbl_end;               -- zero: skip the even/odd check

  -- Step 2: even or odd (MOD of a negative number is negative, so test = 0)
  <<lbl_parity>>
  IF MOD(v_num, 2) = 0 THEN
    DBMS_OUTPUT.PUT_LINE(v_num || ' is EVEN');
  ELSE
    DBMS_OUTPUT.PUT_LINE(v_num || ' is ODD');
  END IF;

  <<lbl_end>>
  NULL;   -- a label must be followed by an executable statement
END;
/
