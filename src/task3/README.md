## Problem statement

You are given an array of structs with the following layout:

| Offset | Size | Field                  | Example      |
|--------|------|------------------------|--------------|
| 0      | 32   | destination            | Cluj-Napoca  |
| 32     | 1    | departingTime.day      | 15           |
| 33     | 1    | departingTime.hour     | 10           |
| 34     | 1    | departingTime.minutes  | 30           |
| 35     | 1    | arrivingTime.day       | 15           |
| 36     | 1    | arrivingTime.hour      | 12           |
| 37     | 1    | arrivingTime.minutes   | 45           |
| 38     | 2    | bag_weight             | 25           |
| 40     | 1    | delayMinutes           | 10           |
| 41     | 1    | delayHours             | 2            |

## Subtask 1 – Apply delays

#### Context

All flights have experienced delays. Each flight structure contains delayMinutes and delayHours fields indicating the delay for that specific flight. You need to update the departure and arrival times for every flight.

Implement the apply_delay function that receives an array of flights and their count, and adds the delay to each flight.

The function has the following header:
<br>
```c
        void apply_delay(struct flight* flights, int nrFlights);
```
<br>

- `RDI` = address of the flights array (struct flight* flights)

- `RSI` = number of flights (int nrFlights)
<br>

The function must be written in the `subtask1.asm` file.

> **Other details** <br>
> You must write your own structures defined in the README (struc flight and any other helpful structs).

> The size of a flight is flught_size (42 bytes).

> The checker will not check the delay fields from the resulting array for any of the subtasks. Up to you if you set those fields to 0, ignore them, etc.

> All flights will still be in the same month, even after applying delays

## Constraints

- 1 ≤ `nrFlights` ≤ 100

---

## Subtask 2 – Filtering Flights by Luggage Weight

#### Context

Implement the filter_flights function that receives the original array, a final array, the number of flights (passed by pointer), and the minimum luggage weight. The function will copy to the final array only the flights with bag_weight >= min_bag_weight and update the count of flights. Update the number of flights (RDX) to reflect the number of elements in the final array.

The function has the following header:
<br>
```c
        void filter_flights(struct flight* origFlights, struct flight* finalFlights, int* nrFlights, int min_bag_weight);
```

<br>

- `RDI` = address of the original Flights array (struct flight* origFlights)
<br>

- `RSI` = address of the final array (struct flight* finalFlights)
<br>

- `RDX` = address of the integer containing the number of flights (int* nrFlights)
<br>

- `RCX` = minimum luggage weight (int min_bag_weight)


The function must be written in the `subtask2.asm` file.

> **Rules** <br>
> Update the value at address nrFlights with the new count of filtered flights.

> Populate the new final flights array

## Constraints

- 1 ≤ `nrFlights` ≤ 100
- 1 ≤ `min_bag_weight` ≤ 100

---

## Subtask 3 – Sorting and Finding the Best Flight

#### Context

You must first sort all flights by arrival time (earliest is best). In case of a tie, the flight with heavier luggage is considered better. Then, you need to search for the first flight matching the requested destination and return it.

The function has the following header:
<br>
```c
        int sort_and_return(struct flight* flights, int nrFlights, struct flight* bestFlight, char* destination);
```
<br>

- `RDI` = address of the flights array (struct flight* flights)

- `RSI` = number of flights (int nrFlights)
<br>

- `RDX` = address of the structure where the found flight will be copied (struct flight* bestFlight)
<br>

- `RCX` =  address of the string representing the searched destination (char* destination)

The function must be written in the `subtask3.asm` file.

> **Rules** <br>
> Sorting rules:

- Compare days (smaller day => earlier => better)
- If days are equal, compare arrivingTime.hour (smaller hour => earlier => better)
- If hours are equal, compare arrivingTime.minute (smaller minute => earlier => better)
- If minutes are also equal, compare bag_weight (larger => better)
- Only compare the arriving values

> Return values:

- `RAX` = 1 if a flight with the requested destination was found

- `RAX` = 0 if no flight with the requested destination exists

- `RDX` = address of the structure that will hold the found ticket, else leave it NULL

## Constraints

- 1 ≤ `nrFlights` ≤ 100
- The destination string will at most be 32 bytes (including the terminator)

### You are engineers, check the ./input & ./ref files for examples. Test 1 will verify subtask 1. Test 2 => subtask 2. Test 3 => subtask 3. Test 4 & 5 verify all subtasks.
