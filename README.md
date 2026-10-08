# plsql-goto-functions-20252SEN228-Jakes

## What I Learned

### 1. GOTO cannot jump *into* an IF block
A `GOTO` can jump **out of** an IF statement (or loop) to a label in the enclosing block, but it can **never jump into** one. Trying to do so gives a compile error:

```
PLS-00375: illegal GOTO statement; this label is inside an IF statement
```

I demonstrated this in `A3_illegal_goto.sql` and fixed it by moving the label outside the IF block, so the IF only decides *whether* to jump.

### 2. PL/SQL runs statements top to bottom
PL/SQL executes statements sequentially, line by line. A `GOTO` interrupts that order: control moves straight to the labeled statement, and execution **continues from that point downward**.

This has a side effect I saw in A1 and A2. After a labeled section finishes, the program does **not** stop. It keeps running into the next section. That is why each section ends with another `GOTO` (for example `GOTO check_parity;`). Without it, the code would fall through and print wrong results, like "7 is NEGATIVE".

### 3. GOTO needs a label
A `GOTO` can only jump to a **label**, which is a name enclosed in double angle brackets:

```sql
GOTO is_positive;      -- jump to the label

<<is_positive>>        -- the label
DBMS_OUTPUT.PUT_LINE('Number is positive');
```

Rules I learned:
- A label must be followed by an **executable statement**. If there's nothing to run, use `NULL;`.
- The label must be in scope, meaning it can't be inside a different IF, loop, or exception handler.

### 4. GOTO vs structured code
In A4 I rewrote the salary review using `IF / ELSIF / ELSE`. It gave the same result and was shorter and easier to follow, which is why GOTO is rarely used in modern code.

## Notes (AI usage)
I used an AI assistant (Claude) to help draft the initial SQL structure. I then ran, tested and reviewed all code myself and can explain it. The reflection is in my own words. Generating clear mds.
I used an AI assistant (GEMINI) for research, clear examples and explanation.
