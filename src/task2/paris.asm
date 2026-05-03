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

check_right:
	mov r8, r10
	mov r9, r11
	inc r9
	lea rcx, [rel check_down]
	jmp validate_move

check_down:
	mov r8, r10
	mov r9, r11
	inc r8
	lea rcx, [rel check_left]
	jmp validate_move

check_left:
	;
	mov r8, r10
	mov r9, r11
	dec r9
	lea rcx, [rel check_up]
	jmp validate_move

check_up:
	;
	mov r8, r10
	mov r9, r11
	dec r8
	lea rcx, [rel stuck]
	jmp validate_move
validate_move:
	; we check the upper bounds of the matrix
	cmp r8, r14
	jg fail_move
	cmp r9, r15
	jg fail_move

	; we check the lower bounds of the matrix (below 0)
	test r8, r8
	js fail_move
	test r9, r9
	js fail_move

	; we check if it is the cell we just came from
	cmp r8, rdi
	jne do_check_char
	cmp r9, rsi
	je fail_move

do_check_char:
	;
	mov rdx, qword [rbx+r8*8]
	mov al, byte [rdx+r9]
	; we check if the char is '0'
	cmp al, '0'
	jne fail_move

	; we save the current position to history and make the step
	mov rdi, r10
	mov rsi, r11
	mov r10, r8
	mov r11, r9
	jmp start_maze

fail_move:
	jmp rcx

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
	;; DO NOT MODIFY