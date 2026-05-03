section .text

;; DO NOT MODIFY
global solve_labyrinth

solve_labyrinth:
	push	rbp
	mov	rbp, rsp
	push	rbx
	push	r12
	push	r13
	push	r14
	push	r15

	mov	r12, rdi
	mov	r13, rsi
	mov	r14, rdx
	mov	r15, rcx
	mov	rbx, r8
	;; DO NOT MODIFY
	;; YOUR CODE STARTS HERE

	; r10 and r11 are the current coordinates
	; rdi and rsi are the coordinates of the previous step

	; we clear the garbage from the upper part of the 64-bit dimensions
	mov r14d, r14d
	mov r15d, r15d
	; we subtract 1 to get m-1
	sub r14, 1
	; we subtract 1 to get n-1
	sub r15, 1
	; we initialize row r10 with 0
	mov r10, 0
	; we initialize column r11 with 0
	mov r11, 0
	; previous cell memory (rdi = row, rsi = column)
	; we initialize with -1 so it doesn't match the first step
	mov rdi, -1
	; we initialize with -1 so it doesn't match the first step
	mov rsi, -1

start_maze:
	; win condition
	cmp r10, r14
	je win
	cmp r11, r15
	je win

check_up:
	; we check if the row is 0
	cmp r10, 0
	je check_left
	mov r8, r10
	dec r8
	; we check if it is the cell we just came from
	cmp r8, rdi
	jne do_check_u
	cmp r11, rsi
	je check_left

do_check_u:
	; 8 is the size in bytes of a pointer
	mov r9, qword [rbx+r8*8]
	mov al, byte [r9+r11]
	; we check if the char is '0'
	cmp al, '0'
	jne check_left
	; we save the current position to history and make the step
	mov rdi, r10
	mov rsi, r11
	mov r10, r8
	jmp start_maze

check_left:
	; we check if the column is 0
	cmp r11, 0
	je check_down
	mov r8, r11
	dec r8
	; we check if it is the cell we just came from
	cmp r10, rdi
	jne do_check_l
	cmp r8, rsi
	je check_down

do_check_l:
	; 8 is the size in bytes of a pointer
	mov r9, qword [rbx+r10*8]
	mov al, byte [r9+r8]
	; we check if the char is '0'
	cmp al, '0'
	jne check_down
	; we save the current position to history and make the step
	mov rdi, r10
	mov rsi, r11
	mov r11, r8
	jmp start_maze

check_down:
	cmp r10, r14
	je check_right
	mov r8, r10
	inc r8
	; we check if it is the cell we just came from
	cmp r8, rdi
	jne do_check_d
	cmp r11, rsi
	je check_right

do_check_d:
	; 8 is the size in bytes of a pointer
	mov r9, qword [rbx+r8*8]
	mov al, byte [r9+r11]
	; we check if the char is '0'
	cmp al, '0'
	jne check_right
	; we save the current position to history and make the step
	mov rdi, r10
	mov rsi, r11
	mov r10, r8
	jmp start_maze

check_right:
	cmp r11, r15
	je stuck
	mov r8, r11
	inc r8
	; we check if it is the cell we just came from
	cmp r10, rdi
	jne do_check_r
	cmp r8, rsi
	je stuck

do_check_r:
	; 8 is the size in bytes of a pointer
	mov r9, qword [rbx+r10*8]
	mov al, byte [r9+r8]
	; we check if the char is '0'
	cmp al, '0'
	jne stuck
	; we save the current position to history and make the step
	mov rdi, r10
	mov rsi, r11
	mov r11, r8
	jmp start_maze

stuck:
	jmp win

win:
	; we save the values
	mov dword [r12], r10d
	mov dword [r13], r11d

	;; YOUR CODE ENDS HERE
	;; DO NOT MODIFY
	pop	r15
	pop	r14
	pop	r13
	pop	r12
	pop	rbx
	pop	rbp
	ret
	;; DO NOT MODIFYs