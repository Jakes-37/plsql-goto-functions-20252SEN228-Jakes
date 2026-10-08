# Reflection

## 1. What does GOTO do in PL/SQL, and what are its rules?

`GOTO` performs an unconditional jump from the GOTO statement to a labeled statement in the same block or subprogram. Its rules are:

- It can only jump to a **label**, written between double angle brackets, like `<<my_label>>`.
- A label must be followed by an **executable statement**. If there is nothing to run, use `NULL;`.
- A GOTO **can jump out of** an IF statement or loop to a label in the enclosing block.
- A GOTO **cannot jump into** an IF statement, loop, or exception handler from outside.

```sql
CASE 1: ILLEGAL GOTO statement: Where the GOTO jumped inside an IF statement
BEGIN
  GOTO inside_if;             -- ERROR: jumps INTO an IF block
  IF 1 = 1 THEN
    <<inside_if>>
    DBMS_OUTPUT.PUT_LINE('Inside IF');
  END IF;
END;
/

CASE 2:

BEGIN
  IF v_num > 0 THEN
    GOTO is_positive;         -- jumps OUT of the IF to a label in the main block
  END IF;

  DBMS_OUTPUT.PUT_LINE('Number is not positive');
  GOTO done;

  <<is_positive>>             -- label, followed by an executable statement
  DBMS_OUTPUT.PUT_LINE('Number is positive');

```
## 2. What error did A3 give you and why?

The error was `PLS-00375: illegal GOTO statement; this label is inside an IF statement`. The cause was the label's placement: I put the label **inside** the IF block and tried to jump to it from outside, and Oracle does not allow jumping into an IF block. To fix it, I moved the label **outside** the IF block, to the same level as the GOTO. The IF statement now only decides whether to jump, and the label sits in the main block.

## 3. A2 vs A4: which is easier to read and maintain, and why?

A4 (IF / ELSIF / ELSE) is much easier to read and maintain than A2 (GOTO). An IF structure reads top to bottom, so you can follow the logic in order. With GOTO, execution jumps around the program, so you have to search for each label to know what runs next.

The computer scientist Edsger Dijkstra made this argument in his 1968 paper "Go To Statement Considered Harmful". He said programs are easier to understand when the code on the page matches the order in which it runs, and unconditional jumps break that match. Heavy use of GOTO also creates "spaghetti code", where the logic is tangled and hard to debug or change.

GOTO may be justified only in rare cases, such as jumping out of deeply nested logic to a single cleanup or exit point. For most work, structured IF and loop statements are better.

## 4. Why use functions instead of repeating the calculation in each query?

A function lets me write a calculation once and call it wherever it is needed, instead of copying and pasting the same logic into every query.

- **Reuse:** the same function works in many queries and programs.
- **One place to fix:** if the rule changes, I edit the function once and every caller is updated.
- **Easier debugging:** bugs are easier to find because the logic lives in one place.
- **Use inside SQL:** functions can be used directly in SELECT, WHERE, and ORDER BY, as in B5.
- **Readability:** a name like `fn_calculate_tax(salary)` is clearer than a long formula.

## 5. How did exception handling help in B2, B3, B4, and C1?

I used two approaches, depending on what each function needed to do.

**`RAISE_APPLICATION_ERROR` (B2, B3):** This stops execution immediately and sends a custom error to the caller. The error number must be between **-20000 and -20999**. In B2, a future hire date raises `ORA-20002`, and in B3 a negative salary raises `ORA-20003`. Invalid data cannot silently pass through the calculation.

```sql
IF p_monthly_salary < 0 THEN
  RAISE_APPLICATION_ERROR(-20003, 'Salary cannot be negative');
END IF;
-- Execution stops here, so the lines below never run for invalid input.
```

**Handling the exception and returning a message (B4, C1):** In B4, `NO_DATA_FOUND` is caught and the function returns `'Unknown Department'` instead of crashing. In C1, `fn_validate_payroll` returns `'VALID...'` or `'INVALID: reason'`. This is useful when checking many employees in one query, because one bad record does not stop the whole result.

**Comparison:**

| | `RAISE_APPLICATION_ERROR` | Returning a message |
|---|---|---|
| Effect | Stops the program and passes an error up | Returns a result and the program carries on |
| Best for | Input that must never be accepted | Reporting a problem without stopping everything |

One caution: simply storing an error message in a variable does not stop execution. The code keeps running unless I check it with IF statements or use `RETURN`.

## 6. What was the hardest part, and what would you do differently?

The hardest part was understanding the whole code, especially how GOTO labels control the flow and how the functions fit together in C1. Next time I will trace each program by hand with different test values before running it, and practise with more exercises on the same topics so I can write the code without relying on examples.
