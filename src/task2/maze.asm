extern printf
extern position
global solve_labyrinth

; you can declare any helper variables in .data or .bss

section .text

; void solve_labyrinth(unsigned int *out_line, unsigned int *out_col, unsigned int m, unsigned int n, char **maze);

solve_labyrinth:
    ;; DO NOT MODIFY
    push    rbp
    mov     rbp, rsp
    push    rbx
    push    r12
    push    r13
    push    r14
    push    r15

    mov     r12, rdi    ; unsigned int *out_line
    mov     r13, rsi    ; unsigned int *out_col
    mov     r14, rdx    ; unsigned int m
    mov     r15, rcx    ; unsigned int n
    mov     rbx, r8     ; char **maze
    ;; DO NOT MODIFY
   
    ;; YOUR CODE STARTS HERE
    
    
    
    ;; YOUR CODE ENDS HERE

    ;; DO NOT MODIFY
    pop     r15
    pop     r14
    pop     r13
    pop     r12
    pop     rbx
    pop     rbp
    ret
    ;; DO NOT MODIFY