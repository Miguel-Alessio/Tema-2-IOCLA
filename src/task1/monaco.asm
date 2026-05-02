section .text

;; DO NOT MODIFY
global fix_lap_times

fix_lap_times:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    push r14
    push r15
    ;; DO NOT MODIFY
    ;; YOUR CODE STARTS HERE

    ; initializam indexul loop-ului cu 0
    mov r12, 0
    ; initializam contorul de erori cu 0
    mov r13, 0

start_loop:
    cmp r12, rdx
    je stop

    mov al, byte [rsi+r12]
    ; 1 reprezinta un tur corupt
    cmp al, 1
    je fixer

    ; 4 este dimensiunea in bytes a unui int
    mov ebx, dword [rdi+r12*4]
    ; 4 este dimensiunea in bytes a unui int
    mov dword [rcx+r12*4], ebx

    inc r12
    jmp start_loop

fixer: 
    inc r13
    ; 0 reprezinta indexul primului sofer
    cmp r12, 0
    je first_driver
    mov r9, rdx
    ; scadem 1 pentru a gasi indexul ultimului sofer
    sub r9, 1
    cmp r12, r9
    je last_driver
    ; -4 reprezinta offsetul pentru soferul anterior
    mov eax, dword [rdi+r12*4-4]
    ; +4 reprezinta offsetul pentru soferul urmator
    add eax, dword [rdi+r12*4+4]
    ; shiftarea la dreapta cu 1 bit impartire la 2
    shr eax, 1 
    jmp save_fix

first_driver:
    ; +4 reprezinta offsetul pentru soferul urmator
    mov eax, dword [rdi+r12*4+4]
    jmp save_fix

last_driver:
    ; -4 reprezinta offsetul pentru soferul anterior
    mov eax, dword [rdi+r12*4-4]

save_fix:
    ; 4 este dimensiunea in bytes a unui int
    mov dword [rcx+r12*4], eax
    inc r12
    jmp start_loop   

stop:
    mov dword [r8], r13d

    ;; YOUR CODE ENDS HERE
    ;; DO NOT MODIFY
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx 
    pop rbp
    ret
    ;; DO NOT MODIFY