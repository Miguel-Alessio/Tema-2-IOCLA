section .text

;; DO NOT MODIFY
global check_column
global check_row
global check_box

; int check_row(int **array, int size, int rowNr)
; rdi = int **array
; rsi = int size
; rdx = int rowNr
check_row:
	push rbp
	mov rbp, rsp
	push rbx
	push r12
	push r13
	push r14
	push r15
	;; DO NOT MODIFY
	;; Your code starts here

	; we initialize the target sum with 0
	xor r15, r15
	; we initialize the target product with 1
	mov r14, 1
	; we initialize the contor to 1
	mov rcx, 1

	; --- CALCULATE TARGET SUM AND PRODUCT IN ONE LOOP ---
calc_targets_row:
	cmp rcx, rsi
	jg finish_targets_row
	; we add to the target sum
	add r15, rcx
	mov rax, r14
	mul rcx
	; we update the target product
	mov r14, rax
	inc rcx
	jmp calc_targets_row

finish_targets_row:
	; we initialize the current sum with 0
	xor r12, r12
	; we initialize the current product with 1
	mov r13, 1
	; we start the column contor from size - 1 (reverse traversal)
	mov rcx, rsi
	dec rcx
	; 8 is the size in bytes of a pointer
	mov r10, [rdi + rdx * 8]

check_loop_row:
	; we check if we reached below 0
	test rcx, rcx
	jl verify_row
	; 4 is the size in bytes of a dword (int)
	mov eax, dword [r10 + rcx * 4]
	; we add to the current sum
	add r12, rax
	; we multiply to the current product
	imul r13, rax
	dec rcx
	jmp check_loop_row

verify_row:
	; we check if sum and product are correct
	cmp r12, r15
	jne not_valid_row
	cmp r13, r14
	jne not_valid_row
	; 1 represents a valid row
	mov rax, 1
	jmp end_check_row

not_valid_row:
	; 0 represents an invalid row
	xor rax, rax

end_check_row:
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

;; DO NOT MODIFY
; int check_column(int **array, int size, int columnNr)
; rdi = int **array
; rsi = int size
; rdx = int columnNr
check_column:
	push rbp
	mov rbp, rsp
	push rbx
	push r12
	push r13
	push r14
	push r15
	;; DO NOT MODIFY
	;; Your code starts here

	; we initialize the target sum with 0
	xor r15, r15
	; we initialize the target product with 1
	mov r14, 1
	; we initialize the contor to 1
	mov rcx, 1

calc_targets_col:
	cmp rcx, rsi
	jg finish_targets_col
	add r15, rcx
	mov rax, r14
	mul rcx
	mov r14, rax
	inc rcx
	jmp calc_targets_col

finish_targets_col:
	; we initialize the current sum with 0
	xor r12, r12
	; we initialize the current product with 1
	mov r13, 1
	; we start the row contor from size - 1 (reverse traversal)
	mov rcx, rsi
	dec rcx

check_loop_col:
	; we check if we reached below 0
	test rcx, rcx
	jl verify_col
	; 8 is the size in bytes of a pointer
	mov r10, [rdi + rcx * 8]
	; 4 is the size in bytes of a dword (int)
	mov eax, dword [r10 + rdx * 4]
	; we add to the current sum
	add r12, rax
	; we multiply to the current product
	imul r13, rax
	dec rcx
	jmp check_loop_col

verify_col:
	cmp r12, r15
	jne not_valid_col
	cmp r13, r14
	jne not_valid_col
	; 1 represents a valid column
	mov rax, 1
	jmp end_check_col

not_valid_col:
	; 0 represents an invalid column
	xor rax, rax

end_check_col:
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

;; DO NOT MODIFY
; int check_box(int **array, int size, int boxNr)
; rdi = int **array
; rsi = int size
; rdx = int boxNr
check_box:
	push rbp
	mov rbp, rsp
	push rbx
	push r12
	push r13
	push r14
	push r15
	;; DO NOT MODIFY
	;; Your code starts here
	; we initialize the target sum with 0
	xor r15, r15
	; we initialize the target product with 1
	mov r14, 1
	; we initialize the contor to 1
	mov rcx, 1

calc_targets_box:
	cmp rcx, rsi
	jg finish_targets_box
	add r15, rcx
	mov rax, r14
	mul rcx
	mov r14, rax
	inc rcx
	jmp calc_targets_box

finish_targets_box:
	; we set the default square root for size 4
	mov r11, 2
	; 9 is the second possible size
	cmp rsi, 9
	jne check_size_16
	; 3 is the square root of 9
	mov r11, 3
	jmp start_box

check_size_16:
	; 16 is the third possible size
	cmp rsi, 16
	jne start_box
	; 4 is the square root of 16
	mov r11, 4

start_box:
	mov rax, rdx
	; we clear rdx for division
	xor rdx, rdx
	; rax = boxNr / sqrt and rdx = remainder
	div r11
	; we save the row index of the box
	mov r8, rax
	; we multiply to get the index of the first row
	imul r8, r11
	; we save the column index of the box
	mov r9, rdx
	; we multiply to get the index of the first column
	imul r9, r11
	; we initialize the current sum to 0
	xor r12, r12
	; we initialize the current product to 1
	mov r13, 1
	; we set the row loop contor to sqrt - 1 (reverse traversal)
	mov rbx, r11
	dec rbx

ext_loop_box:
	; we check if we reached below 0
	test rbx, rbx
	jl verify_box
	; we set the col loop contor to sqrt - 1 (reverse traversal)
	mov rcx, r11
	dec rcx

inner_loop_box:
	; we check if we reached below 0
	test rcx, rcx
	jl next_row_box
	; r10 = start rowNr
	mov r10, r8
	; index row
	add r10, rbx
	; 8 is the size in bytes of a pointer
	mov r10, [rdi + r10 * 8]
	; start of the column
	mov rax, r9
	; index of the column
	add rax, rcx
	; 4 is the size in bytes of a dword (int)
	mov eax, dword [r10 + rax * 4]
	; update the sum and the product
	add r12, rax
	imul r13, rax
	; previous column
	dec rcx
	jmp inner_loop_box

next_row_box:
	; previous row
	dec rbx
	jmp ext_loop_box

verify_box:
	cmp r12, r15
	jne not_valid_box
	cmp r13, r14
	jne not_valid_box
	; 1 represents a valid box
	mov rax, 1
	jmp finish_box

not_valid_box:
	; 0 represents an invalid box
	xor rax, rax

finish_box:
	;; Your code ends here
	;; DO NOT MODIFY
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rbp
	ret