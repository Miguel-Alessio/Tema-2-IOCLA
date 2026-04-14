# Task 2 - The Royal Labyrinth of Versailles (25p)

### Input Representation
A dynamically allocated two-dimensional character matrix (array) is provided. Each element of the matrix satisfies one
of the following conditions:

- Value 1 (ASCII code 0x39): Represents an obstructed cell. Traversal through this cell is prohibited.

- Value 0 (ASCII code 0x30): Represents a free cell. Traversal through this cell is permitted.

### Coordinate System
Let the matrix dimensions be m rows and n columns. Rows are indexed from 0 to m - 1, and columns are indexed from 0 to n - 1. A position within the matrix is denoted by coordinates (row, column).

### Movement Rules
Traversal commences from the origin coordinate (0, 0). From any given position, movement is permitted to adjacent cells in four cardinal directions: up, down, left, or right. Diagonal movement is prohibited.

### Termination Condition
The traversal is considered complete when either of the following conditions is satisfied:

The current row index equals m - 1

The current column index equals n - 1

### Objective
Determine and output the coordinates (row, column) at which the termination condition is first satisfied.

### Problem Constraints
The following guarantees are provided:

- Uniqueness of Path: Exactly one valid traversal path exists from the origin to a terminal cell satisfying the termination condition.

- Local Determinism: From any position except the origin, exactly one neighboring cell represents a forward direction (unvisited), while the remaining neighboring cells (excluding the previous position) are obstructed. The previous position is the cell from which the current position was entered.

### Output Specification
Return the coordinates (row, column) of the cell where the termination condition is met.

The function definition is:

```c
void solve_labyrinth(unsigned int *out_line, unsigned int *out_col, unsigned int m, unsigned int n, char **maze);
```

- `out_line` = pointer to the line index corresponding to the box through which Edi exits the maze
- `out_col` = pointer to the column index corresponding to the box through which Edi exits the maze
- `m` = the number of lines in the maze
- `n` = the number of columns in the maze
- `maze` = the two-dimensional array, dynamically allocated, containing the representation of the maze

**Input:**
- `RDX` = number of lines in the maze
- `RCX` = number of columns in the maze
- `R8`  = pointer to the 2D array of characters (char**) - an array of pointers to strings

**Output:**
- `RDI` = pointer to an unsigned int where the exit line index will be stored
- `RSI` = pointer to an unsigned int where the exit column index will be stored

---

### Extra information
Your code must solve the maze and save the exit line index at the out_line address, and the exit column index at the out_col address.

<img title="Dynamic Array" alt="Dynamic Array" src="../images/maze1.jpg">


A dynamically allocated 2D array has the form shown in the figure below.
Unlike a statically allocated two-dimensional array, in this case we cannot guarantee that successive rows in the array will be placed one after the other in memory, but only that each row is contiguous in memory.
For more details, you can also consult [this section](https://cs-pub-ro.github.io/hardware-software-interface/labs/lab-02/reading/memory-operations.html#reading-pointers) in the lab.

<img title="Dynamic Array" alt="Dynamic Array" src="../images/OiDNd.jpg">

---

## Constraints

### Matrix Dimensions
- 1 ≤ m ≤ 1,000
- 1 ≤ n ≤ 1,000

### Maze Cell Values
- Cell value: 0 or 1 (ASCII '0' or '1')
- 0 = free path (walkable)
- 1 = plant wall (blocked)

### Start Position
- Start cell: (0,0)
- Start cell value: must be 0

### Exit Condition
- Exit reached when: row = m-1 **OR** column = n-1
- Exit cell value: must be 0
- Exit cell coordinates: 0 ≤ out_line ≤ m-1, 0 ≤ out_col ≤ n-1

### Solution Uniqueness
- Number of valid solutions: exactly 1
- No branching paths
- No cycles in the path
- No dead ends except at the official exit

### Movement Constraints
- Directions allowed: up, down, left, right
- Diagonal movement: not allowed
- Valid move target: cell value must be 0

## Memory Constraints
- `maze`: valid pointer to array of m strings
- Each string length: n + 1 (including null terminator)
- Memory allocation: dynamic (provided by caller)