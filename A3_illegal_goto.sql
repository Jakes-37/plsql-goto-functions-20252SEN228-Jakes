-- =====================================================================
-- A3 - Illegal GOTO and Fix
-- Run the whole file (F5 in SQL Developer). Block 1 FAILS on purpose;
-- screenshot the error. Block 2 is the corrected version; screenshot it.
--
-- RULES TO REMEMBER (quiz!):
--  * You CAN jump OUT of an IF, loop, or inner block to a label in an
--    enclosing block.
--  * You CANNOT jump INTO an IF branch, a loop, an inner block, or an
--    exception handler.
--  * You CANNOT jump from an exception handler back into its own block.
--  * A label must be followed by an executable statement (use NULL;).
-- =====================================================================
SET SERVEROUTPUT ON;

-- ---------- BLOCK 1: ILLEGAL (jumps INTO an IF block) ----------------
-- Expected: PLS-00375: illegal GOTO statement; this GOTO cannot branch
--           to label 'LBL_INSIDE'
DECLARE
  v_x NUMBER := 5;
BEGIN
  GOTO lbl_inside;                  -- illegal: label is inside the IF below

  IF v_x > 0 THEN
    <<lbl_inside>>
    DBMS_OUTPUT.PUT_LINE('Inside the IF block');
  END IF;
END;
/

-- ---------- BLOCK 2: FIXED (label moved to the outer level) ----------
-- Jumping OUT of the IF to a label in the enclosing block is legal.
-- Expected output: Reached the label
DECLARE
  v_x NUMBER := 5;
BEGIN
  IF v_x > 0 THEN
    GOTO lbl_show;                  -- legal: jumps out of the IF
  END IF;

  DBMS_OUTPUT.PUT_LINE('This line is skipped when v_x > 0');

  <<lbl_show>>
  DBMS_OUTPUT.PUT_LINE('Reached the label');
END;
/
