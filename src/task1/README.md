# Task 1 (20p)

## Problem Description
Given two parallel arrays of equal length, implement assembly functions to process corrupted telemetry data according to specified repair algorithms.

## Data Structures
Input lap times array (drivers_in_time[]): Unsigned 4-byte integer values representing lap durations

Error flags array (errors[]): 1-byte values where 0 indicates valid data and 1 indicates corrupted data

Output lap times array (drivers_out_time[]): Destination for repaired data

## Array Properties
Both arrays share identical length (num_drivers)

Valid indices range from 0 to num_drivers - 1

Array length satisfies: 1 ≤ num_drivers ≤ 10,000

## Error Enumeration
Objective: Traverse the error flags array sequentially and count occurrences of corrupted entries.

Processing Logic:
- 1.Initialize counter to zero
- 2.Iterate through each element of the error array
- 3.For each element, compare value against 1
- 4.Increment counter when match is found
- 5.Return final count

## Data Repair and Output Generation
Objective: Generate repaired lap times in output array based on error flags and neighbor values from input array.

**Input:**
- `RDI` = address of input lap times array (unsigned int, 4 bytes each)
- `RSI` = address of errors array (char, 1 byte each)
- `RDX` = number of drivers
- `RCX` = address of output lap times array (where to write fixed times)
- `R8` = address of integer where to store the error count

**Output:**
- `drivers_out_time` array is filled with fixed lap times
- `*error_count` (at address R8) is set to number of errors found
- No return value in RAX (void function)

**Example:**

For a given input:
```c
num_drivers =      8
drivers_in_time:  75 82 91 68 79 88 95 73
errors:            0  1  0  1  0  1  0  1
```
Processing:

Index 0: error=0 → copy 75

Index 1: error=1, middle → (75+91)/2 = 83

Index 2: error=0 → copy 91

Index 3: error=1, middle → (91+79)/2 = 85

Index 4: error=0 → copy 79

Index 5: error=1, middle → (79+95)/2 = 87

Index 6: error=0 → copy 95

Index 7: error=1, last → copy previous = 95

Output:
```c
error_count =      4
drivers_out_time: 75 83 91 85 79 87 95 95
```
---

## Constraints

- Array length: 1 ≤ `num_drivers` ≤ 10,000
- Lap times: 60 ≤ `time` ≤ 200 (seconds)
- Error flag: 0 or 1