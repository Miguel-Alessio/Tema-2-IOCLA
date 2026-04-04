; write the structures
struc date
		???
endstruct

struct ticket
		???
endstruct


section .text

global filter_tickets

; void filter_tickets(struct ticket* origTickets, struct ticket* destTickets
;						 int* nrTickets, int min_bag_weight)
; rdi = struct ticket *origTickets
; rsi = struct ticket *destTickets
; rdx = int *nrTickets
; rcx = int min_bag_weight
filter_tickets:
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

	leave
	ret