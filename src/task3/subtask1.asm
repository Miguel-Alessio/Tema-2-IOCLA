; write the structures. make sure it fits the layour in the README
struc date
		???
endstruct

struct ticket
		???
endstruct

section .text

global apply_delay

; void apply_delay(struct ticket* tickets, int nrTickets)
; rdi = struct ticket *tickets
; rsi = int nrTickets
apply_delay:
	;; DO NOT MODIFY
	push rbp
	mov rbp, rsp
	push rbx
	push r12
	push r13
	push r14
	push r15

	;; DO NOT MODIFY

	;; DO NOT MODIFY
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rbp
	ret
	;; DO NOT MODIFY
