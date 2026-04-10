; %include "../include/io.mac"
; extern printf
global sort_and_search

; Driver struct layout (8 bytes total):
;   Offset 0  (4 bytes) - access_level   : 32-bit integer, value 0-100
;   Offset 4  (2 bytes) - nationality    : 0x4445='DE', 0x4F52='RO', 0x4B55='UK', 0x5246='FR'
;   Offset 6  (1 byte)  - is_phantom     : 1=fake, 0=real
;   Offset 7  (1 byte)  - flags          : bit0=under_investigation, bit1=priority_clearance

section .data
    ; optionally, add debug format strings here if needed

section .text

; function signature:
;   sort_and_search(driver *array, int length, int threshold_x)
;
; rdi = address of filtered driver array (from subtask 1)
; rsi = number of drivers in array
; rdx = threshold X (32-bit integer)
;
; The function must:
;   Step 1 - Sort the array IN PLACE, ascending by access_level
;   Step 2 - Binary search for the LEFTMOST driver with access_level >= X
;
; returns:
;   rax = index of found driver (0-based), or -1 if not found
;   rbx = number of comparisons performed during binary search
; -----------------------------------------------------------------------------
sort_and_search:
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


    ;; Step 1: Sort (in place, ascending by access_level)

    ;; Step 2: Binary Search (leftmost access_level >= X)


    ;; Your code ends here

    ;; DO NOT MODIFY
    pop     r15
    pop     r14
    pop     r13
    pop     r12
    pop     rbp
    ret

    ;; DO NOT MODIFY
