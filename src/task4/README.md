## Problem Statement
You are given a 2D array of numbers. The array's size will either be 4x4, 9x9 or 16x16.

Each row of the array has to contain every number fron 1 to the array's size once and no more. This rule also applies to every column.

The array is split into boxes of sqrt(array size) x sqrt(array_size). These boxes also have to follow the rule explained above.

---

### The Task

First, let's recap the rules of sudoku (for a 9x9 board):
- In each row, the digits 1-9 must appear exactly once
- In each column, the digits 1-9 must appear exactly once
- In each box, the digits 1-9 must appear exactly once
- Rows are numbered 0 to 8 from top to bottom.
- Columns are numbered 0 to 8 lef to right.
- Boxes are numbered 0 to 8 from the top-left, and continuing left to right, wrapping around when hitting the right edge of the board (see image).

<!-- ![sudoku](./src/images/sudoku.png) -->
<div align="center">
    <img title="IDS" alt="IDS" src="../images/sudoku.png" width="500" height="450">
</div>

Reminder: some of the tests' board will be of size 4 or 16.

## Subtask 1 - Verify a row
Being given the array, its size and a certain row, verify if the row respects Sudoku's rules.

**Input**
- `RDI` = address of the array
- `RSI` = size of the array
- `RDX` = the row you must verify

**Output**
- `RAX` = 1 if the row respects the rule. 0 if not

---

## Subtask 2 - Verify a column
Being given the array, its size and a certain column, verify if the column respects Sudoku's rules.

**Input**
- `RDI` = address of the array
- `RSI` = size of the array
- `RDX` = the column you must verify

**Output**
- `RAX` = 1 if the column respects the rule. 0 if not

---

## Subtask 3 - Verify a box
Being given the array, its size and a certain box, verify if the box respects Sudoku's rules.

**Input**
- `RDI` = address of the array
- `RSI` = size of the array
- `RDX` = the box you must verify

**Output**
- `RAX` = 1 if the box respects the rule. 0 if not

---

## Constraints

- the matrix and rows/columns/boxes will be indexed starting from 0
- 0 ≤ RDX ≤ array_size - 1
- board size will be 4, 9 or 16

## HINT!
Here is a basic way of checking if a sudoku line/row/box is valid:
((the sum of all numbers == size * (size + 1) / 2) && (the product of all numbers == factorial(size)))

### You are engineers, check the ./input & ./ref files for examples. You must implement all 3 functions in order to receive a score/grade for this task.
