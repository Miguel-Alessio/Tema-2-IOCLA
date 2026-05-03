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

;n*(n+1)/2
calcul_sum:
	;we use r15 to copy the size of the array
	mov r15, rsi
	;increase by one (n+1)
	inc r15
	;needed for multiplication
	mov rax, rsi
	;(n+1)*n
	mul r15
	;shift one bit to the right so we divide by 2, (n+1)*n/2
	shr rax, 1
	;we save the sum in r15
	mov r15, rax

	;we initialize the contor to 1
	mov rbx, 1
	;we initialize the factorial to 1
	mov r14, 1
calculation_factorial:
	cmp rbx, rsi
	je finish_factorial
	inc rbx
	mov rax, r14
	mul rbx
	mov r14, rax
	jmp calculation_factorial

finish_factorial:
	;we initialize the current sum with 0
	mov r12, 0
	;we initialize the current product with 1
	mov r13, 1
	;we initialize the column contor with 0
	mov rcx, 0
	;we get the address of the row
	mov r10, [rdi + rdx * 8]

check_loop:
	cmp rcx, rsi
	je finish_sum_factorial
	;we get the element from the row
	mov eax, dword [r10 + rcx * 4]
	;we add to the current sum
	add r12, rax
	;we multiply to the current product
	imul r13, rax
	inc rcx
	jmp check_loop

finish_sum_factorial:
	;we check if sum and product are correct
	cmp r12, r15
	jne not_valid
	cmp r13, r14
	jne not_valid
	;we return 1 for success
	mov rax, 1
	jmp end_check_row

not_valid:
	;we return 0 for failure
	mov rax, 0

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

	;n*(n+1)/2
calcul_sum_col:
	;we use r15 to copy the size of the array
	mov r15, rsi
	;increase by one (n+1)
	inc r15
	;needed for multiplication
	mov rax, rsi
	;(n+1)*n
	mul r15
	;shift one bit to the right so we divide by 2, (n+1)*n/2
	shr rax, 1
	;we save the sum in r15
	mov r15, rax

	;we initialize the contor to 1
	mov rbx, 1
	;we initialize the factorial to 1
	mov r14, 1
calculation_factorial_col:
	cmp rbx, rsi
	je finish_factorial_col
	inc rbx
	mov rax, r14
	mul rbx
	mov r14, rax
	jmp calculation_factorial_col

finish_factorial_col:
	;we initialize the current sum with 0
	mov r12, 0
	;we initialize the current product with 1
	mov r13, 1
	;we initialize the row contor with 0
	mov rcx, 0

check_loop_col:
	cmp rcx, rsi
	je finish_sum_factorial_col
	;we get the address of the current row
	mov r10, [rdi + rcx * 8]
	;we get the element from the fixed column
	mov eax, dword [r10 + rdx * 4]
	;we add to the current sum
	add r12, rax
	;we multiply to the current product
	imul r13, rax
	inc rcx
	jmp check_loop_col

finish_sum_factorial_col:
	;we check if sum and product are correct
	cmp r12, r15
	jne not_valid_col
	cmp r13, r14
	jne not_valid_col
	;we return 1 for success
	mov rax, 1
	jmp end_check_col

not_valid_col:
	;we return 0 for failure
	mov rax, 0
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

	;n*(n+1)/2
calcul_sum_box:
	;we use r15 to copy the size of the array
	mov r15, rsi
	;increase by one (n+1)
	inc r15
	;needed for multiplication
	mov rax, rsi
	;(n+1)*n
	mul r15
	;shift one bit to the right so we divide by 2, (n+1)*n/2
	shr rax, 1
	;we save the sum in r15
	mov r15, rax

	;we initialize the contor to 1
	mov rbx, 1
	;we initialize the factorial to 1
	mov r14, 1
calculation_factorial_box:
	cmp rbx, rsi
	je finish_factorial_box
	inc rbx
	mov rax, r14
	mul rbx
	mov r14, rax
	jmp calculation_factorial_box

finish_factorial_box:
	;we check if the size is 4
	cmp rsi, 4
	je dim_4
	;we check if the size is 9
	cmp rsi, 9
	je dim_9
	;we check if the size is 16
	cmp rsi, 16
	je dim_16
dim_4:
	;we set the square root of 4
	mov r11, 2
	jmp start_box
dim_9:
	;we set the square root of 9
	mov r11, 3
	jmp start_box
dim_16:
	;we set the square root of 16
	mov r11, 4

start_box:
	mov rax, rdx
	;we put 0 everywhere to clear the register for division
	xor rdx, rdx
	;rax=boxNr/sqrt and rdx=the rest of the division
	div r11
	;we save the row index of the box
	mov r8, rax
	;we multiply to get the index of the first row
	imul r8, r11
	;we save the column index of the box
	mov r9, rdx
	;we multiply to get the index of the first column
	imul r9, r11
	;we initialize the current sum to 0
	mov r12, 0
	;we initialize the current product to 1
	mov r13, 1
	;we set the row loop contor to 0
	mov rbx, 0
ext_loop:
	cmp rbx, r11
	je verify_box
	;we reset the inner loop contor to 0
	mov rcx, 0
inner_loop:
	cmp rcx, r11
	je next_row_box
	;r10=start rowNr
	mov r10, r8
	;index row
	add r10, rbx
	;r10=address of the row
	mov r10, [rdi + r10 * 8]
	;start of the column
	mov rax, r9
	;index of the column
	add rax, rcx
	;extracting the value
	mov eax, dword [r10 + rax * 4]
	;update the sum and the product
	add r12, rax
	imul r13, rax
	;next column
	inc rcx
	jmp inner_loop
next_row_box:
	;next row
	inc rbx
	jmp ext_loop

verify_box:
	cmp r12, r15
	jne not_valid_box
	cmp r13, r14
	jne not_valid_box
	;we return 1 for success
	mov rax, 1
	jmp finish_box

not_valid_box:
	;we return 0 for failure
	mov rax, 0

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