section .text

global count_errors
global fix_lap_times


; Subtask 1: count_errors
; int count_errors(char *errors, int num_drivers)
; Input:  RDI = errors array, RSI = num_drivers
; Output: RAX = number of errors

count_errors:
    ;; DO NOT MODIFY
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    push r14
    push r15
    ;; DO NOT MODIFY
    ;; Your code starts here



    ;; Your code ends here
    ;; DO NOT MODIFY
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret
    ;; DO NOT MODIFY


; Subtask 2: fix_lap_times
; void fix_lap_times(unsigned int *in_times, char *errors, 
;                    int num_drivers, unsigned int *out_times, 
;                    int *error_count)
; Input:  
;   RDI = in_times array
;   RSI = errors array
;   RDX = num_drivers
;   RCX = out_times array
;   R8  = error_count pointer

fix_lap_times:
    ;; DO NOT MODIFY
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    push r14
    push r15
    ;; DO NOT MODIFY
    ;; Your code starts here



    ;; Your code ends here
    ;; DO NOT MODIFY
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret
    ;; DO NOT MODIFY