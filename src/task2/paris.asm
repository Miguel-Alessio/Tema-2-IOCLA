extern printf
extern position
global solve_labyrinth

; you can declare any helper variables in .data or .bss

section .text


solve_labyrinth:
    ;; DO NOT MODIFY
    push    rbp
    mov     rbp, rsp
    push    rbx
    push    r12
    push    r13
    push    r14
    push    r15

    mov     r12, rdi
    mov     r13, rsi
    mov     r14, rdx
    mov     r15, rcx
    mov     rbx, r8
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