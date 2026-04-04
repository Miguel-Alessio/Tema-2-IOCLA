%include "../include/io.mac"

extern printf
global count_errors

section .data
	; optionally, add debug formats here if needed

section .text

; function signature: 
; int count_errors(char *errors, int num_drivers);
; rdi = errors array address
; rsi = num_drivers

count_errors:
	;; DO NOT MODIFY
	push    rbp
	mov     rbp, rsp
	push    rbx
	push    r12
	push    r13
	push    r14
	push    r15
	;; DO NOT MODIFY

	;; Your code starts here
	
	;; Your code ends here
	
	;; DO NOT MODIFY
	pop     r15
	pop     r14
	pop     r13
	pop     r12
	pop     rbx
	pop     rbp
	ret
	;; DO NOT MODIFY
