%include "../include/io.mac"
extern printf
global insert_honeypot

; Driver struct layout (8 bytes total):
;   Offset 0  (4 bytes) - access_level   : 32-bit integer, value 0-100
;   Offset 4  (2 bytes) - nationality    : 0x4445='DE', 0x4F52='RO', 0x4B55='UK', 0x5246='FR'
;   Offset 6  (1 byte)  - is_phantom     : 1=fake, 0=real
;   Offset 7  (1 byte)  - flags          : bit0=under_investigation, bit1=priority_clearance

section .data
    ; optionally, add debug format strings here if needed

section .text


; function signature:
;   insert_honeypot(driver *array, int length, int threshold_x)
;
; rdi = address of sorted filtered driver array (from subtask 2)
; rsi = number of drivers in array (before insertion)
; rdx = threshold X (same value used in subtask 2)
;
; The function must:
;   Step 1 - Compute honeypot access_level:
;              average of access_level of drivers with access_level in [X, 2*X]
;              AND priority_clearance flag set (bit1 of flags == 1)
;              Fallback: average of ALL drivers if none qualify
;              Fallback: 0 if array is empty
;   Step 2 - Build honeypot struct:
;              access_level = computed average
;              nationality  = 0x4F52 (RO)
;              is_phantom   = 0
;              flags        = 0b11 (both bits set)
;   Step 3 - Insert honeypot at correct sorted position (ascending access_level)
;              If tie, insert BEFORE the first driver with the same access_level
;              Shift elements right to make room (buffer has capacity for n+1)
;   Step 4 - Compute XOR hash:
;              XOR all 8-byte structs as 64-bit integers across the final array
;
; returns:
;   rax = address of final array (same static buffer from subtask 1)
;   rbx = new length (original length + 1)
;   rcx = index where honeypot was inserted
;   rdx = 64-bit XOR hash of the final array

insert_honeypot:
    ;; DO NOT MODIFY
    push    rbp
    mov     rbp, rsp
    push    rbx
    push    r12
    push    r13
    push    r14
    push    r15
    ;; DO NOT MODIFY

    ;; Your code starts here

    ;; --- Step 1: Compute honeypot access_level ---
    ;; Suggested register usage:
    ;;   r12 = base address of array
    ;;   r13 = loop index
    ;;   r14 = accumulator (sum of qualifying access_levels)
    ;;   r15 = count of qualifying drivers

    ;; --- Step 2: Build honeypot struct ---
    ;; Build the 8-byte struct in a register or on the stack,
    ;; then write it into the array at the correct position.

    ;; --- Step 3: Insert at sorted position ---
    ;; Find the first index where access_level > honeypot.access_level,
    ;; shift elements right, write honeypot.

    ;; --- Step 4: Compute XOR hash ---
    ;; Iterate over all (length+1) structs, XOR each as a 64-bit value.

    ;; Your code ends here

    ;; DO NOT MODIFY
    pop     r15
    pop     r14
    pop     r13
    pop     r12
    pop     rbp
    ret
    ;; DO NOT MODIFY
