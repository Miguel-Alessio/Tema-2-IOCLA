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

	; we initialize the error contor with 0
	mov r13, 0
	; we set the loop index to the number of drivers
	mov r12, rdx
	; we subtract 1 to get the last index
	sub r12, 1

start_loop:
	; we check if the loop index is less than 0
	cmp r12, 0
	jl stop

	mov al, byte [rsi+r12]
	; 1 represents a corrupted lap
	cmp al, 1
	je fixer

	; 4 is the size in bytes of an int
	mov ebx, dword [rdi+r12*4]
	; 4 is the size in bytes of an int
	mov dword [rcx+r12*4], ebx

	; we decrement the index
	dec r12
	jmp start_loop

fixer:
	inc r13
	; we check if it is the first driver
	cmp r12, 0
	je first_driver
	; we copy the total number of drivers
	mov r9, rdx
	; we subtract 1 to find the index of the last driver
	sub r9, 1
	; we check if it is the last driver
	cmp r12, r9
	je last_driver
	; -4 is the offset for the previous driver
	mov eax, dword [rdi+r12*4-4]
	; +4 is the offset for the next driver
	add eax, dword [rdi+r12*4+4]
	; right shift by 1 bit divides by 2
	shr eax, 1 
	jmp save_fix

first_driver:
	; +4 is the offset for the next driver
	mov eax, dword [rdi+r12*4+4]
	jmp save_fix

last_driver:
	; -4 is the offset for the previous driver
	mov eax, dword [rdi+r12*4-4]

save_fix:
	; 4 is the size in bytes of an int
	mov dword [rcx+r12*4], eax
	; we decrement the index
	dec r12
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