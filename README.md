# Homework 2 - Coding Across Europe: Eli and Edi’s Adventure

**Authors**
- Kaan Nasurla
- Victor Davidescu

---

### DEADLINE SOFT: 30.04.2026
### DEADLINE HARD: 05.05.2026

---

#### Eli & Edi are back!
Following the first task, Eli and Edi — our freshman students — returned with new challenges for you. In their mission to escape Instagram’s endless scroll, they begun implementing a much more powerful algorithm that will revolutionize the world. In building this top-secret algorithm, Eli is looking for help with implementing certain parts she can’t handle right now and Edi want to optimize Eli's work!

<div align="center">
    <img title="IDS" alt="IDS" src="./src/images/intro.png" width="700" height="1500">
</div>

**Eli advises you to complete the assignment on the PCLP2 virtual machine.**
**If you're working on a different system (WSL, native Linux), Edi advises you to also test your solution on the PCLP2 virtual machine.**

---

The unbeatable duo from homework 1 continues their adventure in topic 2, only this time you get to know each other better, and because you are friends, they reveal their real identities: Elisa and Eduard. The two tell you that they have been inseparable friends since the first day of college, from the first programming course where they sat next to each other. They share common passions and interests, including traveling, technology, and having fun with friends.

After an academic year full of exams, assignments, and projects, they decided to celebrate their success with a memorable vacation through the great cities of Europe. Although they are excited about the adventure, they know that in each destination an assembly programming challenge awaits them — the subject that made them both suffer and fall in love with computers.

In order to enjoy the landscapes and atmosphere of each place without worries, they need your help. So, from now on, throughout the journey, the two friends will become Elisa (Eli) and Eduard (Edi) for you, and you will be their traveling partner on this European adventure.

Their first destination was Paris. As the plane slowly descended, Eli pressed her face against the window, fascinated by the glowing city lights, while Edi was already thinking ahead, planning routes and schedules.

- “First stop: the Eiffel Tower. Second stop: food,” Edi said with a confident smile. 😁

- “Third stop: somehow solving the assembly challenge waiting for us,” Eli added, laughing. 😅

From that moment, you realized this trip would be anything but ordinary.

The next morning, after enjoying fresh croissants and hot coffee at a small, cozy café, the three of you headed toward the Eiffel Tower. The streets were full of life — musicians playing on the sidewalks, artists painting, and tourists exploring every corner.

Everything felt perfect… until Edi’s phone suddenly buzzed. He froze for a second. “I think it’s time.” Eli leaned closer as he opened the message. You read it together:

“Welcome to Paris! Your challenge: decode the hidden message using bitwise operations. Only then will you unlock your next destination.”

The three of you found a quiet place in a nearby park. Edi opened his laptop, Eli started writing ideas in her notebook, and you joined them, ready to help. At first, the sequence of numbers seemed completely random.

- “Maybe we should try XOR operations,” Eli suggested thoughtfully.

- “Or bit shifting,” you added.

Time passed quickly, but step by step, the puzzle began to make sense. Working together, combining your ideas, you finally reached a solution. With a deep breath, Edi pressed “run.” For a moment, nothing happened. Then, a new message appeared on the screen:

**“Congratulations. Next destination: French Riviera.”**

- Eli jumped up excitedly. “We did it!”

- Edi smiled, closing his laptop. “And this is just the beginning.”

As the sun slowly set behind the Eiffel Tower, casting a warm golden light over the city, you realized that this journey was more than just a vacation. It was about challenges, teamwork, and friendship.

Pack your bags and take the Paris metro to Charles de Gaulle Airport!

And deep down, you knew one thing for sure: the adventure had only just begun!

<div align="center">
    <img title="IDS" alt="IDS" src="./src/images/airport.png" width="1000" height="1900">
</div>

---
## Task 1 - Monaco Grand Prix (20p)


### The Story

Eli and Edi have just arrived in Monte Carlo, the heart of luxury and speed. It's Formula 1 Grand Prix weekend, and the atmosphere is electrifying. While taking Instagram-worthy photos of each other along the famous harbor, they notice a distressed Ferrari engineer staring at a dead screen.

The team's telemetry system has crashed exactly when they needed real-time calculations for race strategy. Without live data, they cannot optimize tire degradation or fuel consumption. The former programmer left two weeks ago, and no one understands the legacy assembly code that powers the low-level telemetry processing.

Spotting Eli's and Edi's laptops in their backpacks, the engineer approaches them with a desperate plea: "You look like you know computers! We have 10 minutes before the next pit window. Please help us fix this data!"

The engineer explains that the telemetry system stores car performance data in two parallel arrays:
- One array contains lap times (in seconds)
- One array contains error flags (1 = corrupted, 0 = OK)

Due to a sensor malfunction, some cars have corrupted data, and their lap times need to be repaired before the strategy algorithm can run.

Eli and Edi immediately think of you, their programming partner. They know you can write the fast assembly code needed to traverse the arrays, identify errors, and fix the corrupted values – all in the blink of an eye, just like the Formula 1 cars speeding around the circuit!


<div align="center">
    <img title="IDS" alt="IDS" src="./src/images/monaco.png" width="1000" height="1900">
</div>

---

## Problem Statement

You are given two parallel arrays:
- `drivers_in_time[]` – array of lap times (unsigned integers, 4 bytes each)
- `errors[]` – array of error flags (char/byte, 1 byte each, 0 = OK, 1 = corrupted)

Both arrays have the same length (`num_drivers`).

Your task is to repair the corrupted data, generate the fixed lap times in an output array, and return statistics about the errors found.

---

## Subtask 1 – Counting Errors

Traverse the entire array and count how many cars have the error flag set to 1.

**Input:**
- `RDI` = address of errors array (pointer to first byte)
- `RSI` = number of drivers (array length)

**Output:**
- `RAX` = total number of drivers with error flag = 1
---

## Subtask 2 – Modify the Array – Fix Corrupted Lap

After counting the errors, generate the fixed lap times in the output array according to these rules:

- If a driver has `error == 0`, copy its `time` unchanged to the output array..
- If a driver has `error == 1`, repair its `time` field using the following logic:
  - If the corrupted driver has **both** a previous and a next driver in the array → set its time to the **average** of the previous driver's time and the next driver's time (integer division, round down).
  - If the corrupted driver is the **first** element (no previous driver) → set its time equal to the **next** driver's time.
  - If the corrupted driver is the **last** element (no next driver) → set its time equal to the **previous** driver's time.

**Important:** When computing the fix for a corrupted driver, use the original (input) values from the neighbors in drivers_in_time, not the values that might have already been written to drivers_out_time.

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


---

## Subtask 3 – Return the Fixed Array and Verification

After performing the repairs, return the modified array to the caller and also compute a simple **checksum** of all lap times (sum of all `time` fields) after repair.

**Input:**
- `RDI` = address of input lap times array
- `RSI` = address of errors array
- `RDX` = number of drivers
- `RCX` = address of output lap times array
- `R8` = address of integer where to store the error count

**Output:**
- `RAX` = checksum (sum of all `time` fields in ` drivers_out_time` after repair)
- `*error_count` (at address R8) = number of errors fixed
- `drivers_out_time` array is filled with fixed lap times

---

## Constraints

- Array length: 1 ≤ `num_drivers` ≤ 10,000
- Lap times: 60 ≤ `time` ≤ 200 (seconds)
- Error flag: 0 or 1

---

## Task 2 - Frankfurt: Phantom Driver Cyber Attack (25p)
<br>
### The Story

After their heroic rescue of Ferrari's telemetry system in Monaco, Eli and Edi board a flight to Frankfurt, the financial heart of Europe. They plan to relax in the famous Palmengarten gardens, but fate has other plans.

As they exit the airport, Eli's phone rings. It's Kaan, a friend from university who now works as a security engineer at Deutsche Bank. His voice is trembling: "The signal processing system for our armored truck fleet has been infected. A malware called 'Phantom Driver' is injecting fake driver profiles into our arrays. Our routing algorithms can't distinguish real drivers from ghosts, and we're losing millions in delayed deliveries!"

<div align="center">
    <img title="IDS" alt="IDS" src="./src/images/frankfurt.jpeg" width="700" height="1000">
</div>


### Subtask 1

For this subtask, you have to check if the date of each event is valid, based
on the next rules:

- The year should be between 1990 and 2030
- The month should be between 1 and 12
- The day should be between 1 and the last day of each month (e.g. for January the last day is 31, for February, it is 28)

If a date is valid, set the `valid` flag in the `event` structure to 1 (True), to 0 (False) otherwise.

The function definition is:

```c
void check_events(struct event *events, int len);
```

The arguments are:

- **events:** start address of the events array
- **len:** number of events in the array

### Subtask 2

For this subtask, you have to sort the events resulted after the first subtask
following the next steps while comparing two events:

- if an event is valid, it is **not** considered greater, which means all the valid events should come first
- if two events are valid, they should be sorted by their date, by year, then by month, then by date
- if the dates of two events are equal, they should be sorted like using `strcmp()` function by their name and using its result, so if the result is negative, it means the first name should come first in the sorted array

The sorting should be done **in place**, that means that the array given as input should contain the sorted
events and that is what will be checked.

The function definition is:

```c
void sort_events(struct event *events, int len);
```

The arguments are:

- **events:** start address of the events array
- **len:** number of events in the array

**All the data in the structures will be limited to their data type size and the name of the events is unique!**

#### **Important Notice**

For the second subtask will be used the same array given as input in the first subtask, this means that any wrong modifications of the structures during the first subtask will affect the second task and it will result in a failed test. The second subtask can not be completed without completing the first subtask.

<br>


## Task 3 - The London Airport Challenge (25p)

### The Story

After their success in Frankfurt, Eli, Edi, and you flew to London. The city welcomed you with its characteristic fog and the iconic sound of a double-decker bus passing by Big Ben. You had plane tickets for the journey home, but there was a problem: all flights had massive delays due to a storm in Northern Europe. The airline needed your help.

"Welcome to Heathrow Airport!" the agent at the desk said. "We need your help with three tasks related to the plane tickets."

First, you had to apply the delays to every ticket. For each flight, you added the delay minutes to both departure and arrival times. If minutes exceeded 59, you carried over to hours. If hours exceeded 23, you carried over to days. Soon, every flight showed the correct new schedule.

Second, the airline wanted to filter passengers with unsuitable luggage. Because of the storm, planes with too light of a load are vulnarable to heavy winds. Take out from the timetable any tickets that have a bag weight too low. 

Finally, it's time to find the best ticket for Eli & Edi's next destinaton. Sort the ticket array  in place(first by day, then by hour, then by minute, then by weight, a heavier luggage limit being considered better). Implement whatever sorting algorithm you want. Return 1 if there is a ticket going to Eli & Edi's wanted destination or 0 if not. 

The agent thanked you warmly. As you left the airport, the London fog began to lift, revealing a beautiful sunset over the city. Another challenge completed, another city conquered. Your European adventure continued, one assembly task at a time. ✈️

<div align="center">
    <img title="IDS" alt="IDS" src="./src/images/bigben.png" width="1000" height="1900">
</div>

---

## Problem statement

---

You are given an array of structs of type ticket with the following layout:

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
|-------------------------------------------------------|

The next subtasks will tests your ability to work with arrays of structs in asm. You are expected to write your own structs following this layour.

## Subtask 1 – Apply delays

#### Context

Due to the storm in Northern Europe, all flights have experienced delays. Each plane ticket contains delayMinutes and delayHours fields indicating the delay for that specific flight. You need to update the departure and arrival times for every ticket.

**Requirement:** Implement the apply_delay function that receives an array of tickets and their count, and adds the delay to each ticket.


You will have to implement the delay algorithm, the function you have to implement has the following header:
<br>
```c
        void apply_delay(struct ticket* tickets, int nrTickets);
```
<br>

-> RDI = address of the tickets array (struct ticket* tickets)

-> RSI = number of tickets (int nrTickets)
<br>

The function must be completed in the `subtask1.asm` file.

> **Other details** <br>
> You must write your own structures defined in the README (struc date and struc ticket).

> The size of a ticket is ticket_size (42 bytes).

> The delayMinutes and delayHours fields are located at the end of the structure.

---

## Subtask 2 – Filtering Tickets by Luggage Weight

#### Context

The airline wants to keep only passengers who have sufficiently heavy checked luggage. You need to copy into a new array only the tickets that meet the minimum weight requirement.

**Requirement:** Implement the filter_tickets function that receives the original tickets array, a destination array, the number of tickets (passed by pointer), and the minimum luggage weight. The function will copy to the destination array only the tickets with bag_weight >= min_bag_weight and update the ticket count.

The function you have to implement has the following header:
<br>
```c
        void filter_tickets(struct ticket* origTickets, struct ticket* destTickets, int* nrTickets, int min_bag_weight);
```

<br>

-> RDI = address of the original tickets array (struct ticket* origTickets)
<br>

-> RSI = address of the destination array (struct ticket* destTickets)
<br>

-> RDX = address of the integer containing the number of tickets (int* nrTickets)
<br>

-> RCX = minimum luggage weight (int min_bag_weight)


The function must be completed in the `subtask2.asm` file.

> **Rules** <br>
> Update the value at address nrTickets with the new count of filtered tickets.

> Populate the new destination tickets array

---

## Subtask 3 – Sorting and Finding the Best Ticket

#### Context

You must first sort all tickets by arrival time (earliest is best). In case of a tie, the ticket with heavier luggage is considered better. Then, you need to search for the first ticket matching the requested destination and return it.

The function you have to implement has the following header:
<br>
```c
        int sort_and_return(struct ticket* tickets, int nrTickets, struct ticket* bestTicket, char* destination);
```
<br>

-> RDI = address of the tickets array (struct ticket* tickets)

-> RSI = number of tickets (int nrTickets)
<br>

-> RDX = address of the structure where the found ticket will be copied (struct ticket* bestTicket)
<br>

-> RCX =  address of the string representing the searched destination (char* destination)

The function must be completed in the `subtask3.asm` file.

> **Rules** <br>
> Sorting rules (descending priority - smaller = better for times):

- Compare days (smaller day = earlier = better)
- If days are equal, compare arrivingTime.hour
- If hours are equal, compare arrivingTime.minute
- If minutes are also equal, compare bag_weight (larger = better)
- Only compare the arriving values, Eli & Edi don't care about the departing times for this task

> Return values:

- RAX = 1 if a ticket with the requested destination was found

- RAX = 0 if no ticket with the requested destination exists

> Notes: 

- The destination string will at most be 32 bytes (including the terminator)


## Task 4 - Sudoku (20p)

### The Story

Eli and Edi have just boarded their next flight and find themselved a bit bored. What is there to do on long and monotone flight? Luckily, Eli comes up with a nice way of passing time: playing Sudoku!

What he would usually do is check out [his favourite sudoku youtuber](https://www.youtube.com/channel/UCC-UOdK8-mIjxBQm_ot1T-Q) and choose a sudoku from there, but today he wanted to take a break from all the technology and go old-school: Pen and Paper.
There is one problem though: he wants to be 100% sure he didn't make any mistakes.
Help him out by making a small checker that tells him which rows, columns, or boxes are wrong (if any).

<div align="center">
    <img title="IDS" alt="IDS" src="./src/images/plane.png" width="700" height="1500">
</div>


## Problem Statement
You are given a 2D array of numbers. The array's size will either be 4x4, 9x9 or 16x16.

Each row of the array has to contain every number fron 1 to the array's size once and no more. This rule also applies to every column.

The array is split into boxes of sqrt(array size) x sqrt(array_size). These boxes also have to follow the rule explained above.

---

### The Task

First, let's recap the rules of sudoku:
- In each row, the digits 1-9 must appear exactly once
- In each column, the digits 1-9 must appear exactly once
- In each box, the digits 1-9 must appear exactly once
- Rows are numbered 0 to 8 from top to bottom.
- Columns are numbered 0 to 8 lef to right.
- Boxes are numbered 0 to 8 from the top-left, and continuing left to right, wrapping around when hitting the right edge of the board (see image).

<!-- ![sudoku](./src/images/sudoku.png) -->
<div align="center">
    <img title="IDS" alt="IDS" src="./src/images/sudoku.png" width="500" height="450">
</div>

Reminder: Eli and Edi are crafty people and will not stick to Sudoku boards of size 9. Some of the tests' board will be of size 4 or 16.

## Subtask 1 - Verify a row
Being given the array, its size and a certain row, verify if the row respects Sudoku's rule.

**Input**
- `RDI` = address of the array
- `RSI` = size of the array
- `RDX` = the row you must verify

**Output**
- `RAX` = 1 if the row respects the rule. 0 if not

---

## Subtask 2 - Verify a column
Being given the array, its size and a certain column, verify if the column respects Sudoku's rule.

**Input**
- `RDI` = address of the array
- `RSI` = size of the array
- `RDX` = the column you must verify

**Output**
- `RAX` = 1 if the column respects the rule. 0 if not

---

## Subtask 3 - Verify a box
Being given the array, its size and a certain box, verify if the box respects Sudoku's rule.

**Input**
- `RDI` = address of the array
- `RSI` = size of the array
- `RDX` = the box you must verify

**Output**
- `RAX` = 1 if the box respects the rule. 0 if not

---

## Extra information
As the matrix will be indexed starting from 0, so will the rows/columns/boxes. Thus, rdx will hold values from 0 to (array_size - 1)

## HINT!
Here is a basic way of checking if a sudoku line/row/box is valid:
((the sum of all numbers == size * (size + 1) / 2) && (the product of all numbers == factorial(size)))
The sudoku board is given as an 81-long char array, and the other three arguments represent which row, column, or box to check as an integer between 0 and 8.

---

## Coding Style & README (10p)

To be able to use your solutions in the implementation of the secret algorithm, Eli needs well-structured and readable assembly code that follows a few good practice rules:

- writing readable code
- consistent indentation (the recommendation is to place labels at the beginning of the line and indent instructions with one tab)
- using meaningful names for labels
- including **relevant and necessary** comments in the code
- writing code lines (or README) with a maximum of 80–100 characters

You will also need to include a brief explanation of the solution for each task in a README file, this is a requirment from Edi.

**The score for coding style and README is not included in the checker and will be awarded during evaluation.**

---

## Checker

To use the checker `local_checker.py`:
<br>
-> you need to have Python3 installed
<br>
-> you need to be in `./src`.


To view the list of possible script arguments:

```bash
    python3 local_checker.py --help
```

To run all tests:

```bash
    python3 local_checker.py --all
```
To create the archive that you need to upload on Moodle (**does not include the README; you must manually add this file to the final archive**):

```bash
    python3 local_checker.py --zip
```

During a normal run, the checker will not keep your outputs—it will perform a clean.
To keep the outputs, add the `--no_clean` argument when running the checker.

---

**Eli and Edi thanks you for your help and looks forward to seeing you for Assignment 3 from PCLP2 as well!!**
<div align="center">
    <img title="IDS" alt="IDS" src="./src/images/beach.png" width="1000" height="2000">
</div>
