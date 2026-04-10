%include "../include/io.mac"
extern printf
global filter_drivers

; Driver struct layout (8 bytes total):
;   Offset 0  (4 bytes) - access_level   : 32-bit integer, value 0-100
;   Offset 4  (2 bytes) - nationality    : 0x4445='DE', 0x4F52='RO', 0x4B55='UK', 0x5246='FR'
;   Offset 6  (1 byte)  - is_phantom     : 1=fake, 0=real
;   Offset 7  (1 byte)  - flags          : bit0=under_investigation, bit1=priority_clearance

section .bss
    output_buffer resb 8192     ; static buffer: 1024 drivers * 8 bytes each

section .data
    ; optionally, add debug format strings here if needed

section .text

; filter_drivers(driver *input_array, int num_drivers)
;   rdi = address of input driver array
;   rsi = number of drivers in input array
;
; returns:
;   rax = address of output_buffer (filtered drivers)
;   rbx = number of drivers written to output_buffer

filter_drivers:
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


    ;; Your code ends here

    ;; DO NOT MODIFY
    pop     r15
    pop     r14
    pop     r13
    pop     r12
    pop     rbp
    ret

    ;; DO NOT MODIFY
