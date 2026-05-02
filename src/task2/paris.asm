section .text

;; DO NOT MODIFY
global solve_labyrinth

solve_labyrinth:
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
    
    ;r10 si r11 sunt coordonatele actuale
    ;rdi si rsi sunt coordonatele la pasul anterior

    ;curatam gunoiul din partea superioara a dimensiunilor pe 64 de biti
    mov r14d, r14d
    mov r15d, r15d
    ;obtinem m-1 si n-1
    sub r14, 1
    ;
    sub r15, 1
    ;linia r10 si coloana r11
    mov r10, 0
    ;
    mov r11, 0
    ;memoria celulei anterioare (rdi = linia, rsi = coloana)
    ;initializam cu -1 ca sa nu se potriveasca cu nicio coordonata la primul pas
    mov rdi, -1
    ;
    mov rsi, -1
start_maze:
    ;conditia de victorie
    cmp r10, r14
    je win
    cmp r11, r15
    je win
    
check_right:
    cmp r11, r15
    je check_down
    mov r8, r11
    inc r8
    ;verificam daca e celula din care tocmai am venit
    cmp r10, rdi
    jne do_check_r
    cmp r8, rsi
    je check_down
do_check_r:
    ;
    mov r9, qword [rbx+r10*8]
    mov al, byte [r9+r8]
    ;
    cmp al, '0'
    jne check_down
    ;salvam pozitia curenta la istoric si facem pasul
    mov rdi, r10
    mov rsi, r11
    mov r11, r8
    jmp start_maze
check_down:
    cmp r10, r14
    je check_left
    mov r8, r10
    inc r8
    cmp r8, rdi
    jne do_check_d
    cmp r11, rsi
    je check_left
do_check_d:
    ;
    mov r9, qword [rbx+r8*8]
    mov al, byte [r9+r11]
    ;
    cmp al, '0'
    jne check_left
    mov rdi, r10
    mov rsi, r11
    mov r10, r8
    jmp start_maze
check_left:
    ;
    cmp r11, 0
    je check_up
    mov r8, r11
    dec r8
    cmp r10, rdi
    jne do_check_l
    cmp r8, rsi
    je check_up
do_check_l:
    ;
    mov r9, qword [rbx+r10*8]
    mov al, byte [r9+r8]
    ;
    cmp al, '0'
    jne check_up
    mov rdi, r10
    mov rsi, r11
    mov r11, r8
    jmp start_maze

check_up:
    ;
    cmp r10, 0
    je stuck
    mov r8, r10
    dec r8
    cmp r8, rdi
    jne do_check_u
    cmp r11, rsi
    je stuck

do_check_u:
    ;
    mov r9, qword [rbx+r8*8]
    mov al, byte [r9+r11]
    ;
    cmp al, '0'
    jne stuck
    mov rdi, r10
    mov rsi, r11
    mov r10, r8
    jmp start_maze
stuck:
    jmp win
win:
    ; Salvam valorile
    mov dword [r12], r10d
    mov dword [r13], r11d

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