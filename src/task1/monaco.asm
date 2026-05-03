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

	; we initialize the loop index with 0
	mov r12, 0
	; we initialize the error contor with 0
	mov r13, 0

	; 0 represents the index of the first driver
	mov al, byte [rsi+r12]
	; 1 represents a corrupted lap
	cmp al, 1
	je first_driver_fix

	; 4 is the size in bytes of an int
	mov ebx, dword [rdi+r12*4]
	; 4 is the size in bytes of an int
	mov dword [rcx+r12*4], ebx
	jmp prepare_loop

first_driver_fix:
	inc r13
	; +4 is the offset for the next driver
	mov eax, dword [rdi+r12*4+4]
	; 4 is the size in bytes of an int
	mov dword [rcx+r12*4], eax

prepare_loop:
	inc r12
	mov r9, rdx
	; we subtract 1 to find the index of the last driver
	sub r9, 1

start_loop:
	cmp r12, r9
	je last_driver_check

	mov al, byte [rsi+r12]
	; 1 represents a corrupted lap
	cmp al, 1
	je fixer

	; 4 is the size in bytes of an int
	mov ebx, dword [rdi+r12*4]
	; 4 is the size in bytes of an int
	mov dword [rcx+r12*4], ebx

	inc r12
	jmp start_loop

fixer: 
	inc r13
	; -4 is the offset for the previous driver
	mov eax, dword [rdi+r12*4-4]
	; +4 is the offset for the next driver
	add eax, dword [rdi+r12*4+4]
	; right shift by 1 bit divides by 2
	shr eax, 1 
	; 4 is the size in bytes of an int
	mov dword [rcx+r12*4], eax
	inc r12
	jmp start_loop

last_driver_check:
	mov al, byte [rsi+r12]
	; 1 represents a corrupted lap
	cmp al, 1
	je last_driver_fix

	; 4 is the size in bytes of an int
	mov ebx, dword [rdi+r12*4]
	; 4 is the size in bytes of an int
	mov dword [rcx+r12*4], ebx
	jmp stop

last_driver_fix:
	inc r13
	; -4 is the offset for the previous driver
	mov eax, dword [rdi+r12*4-4]
	; 4 is the size in bytes of an int
	mov dword [rcx+r12*4], eax

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