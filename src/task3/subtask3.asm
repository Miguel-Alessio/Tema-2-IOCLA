; write the structures
; struc date
; 		???
; endstruct

; struct ticket
; 		???
; endstruct


section .text
global sort_and_return

; int sort_and_return(struct ticket* tickets, int nrTickets, 
;                      struct ticket* bestTicket, char destination[32])
; rdi = tickets (pointer)
; rsi = nrTickets (value)
; rdx = bestTicket (pointer to pre-allocated struct)
; rcx = destination (pointer to 32-byte string)
sort_and_return:
	;; DO NOT MODIFY
	push rbp
	mov rbp, rsp
	push rbx
	push r12
	push r13
	push r14
	push r15
	;; DO NOT MODIFY

.done:
	;; DO NOT MODIFY
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rbp
	ret
	;; DO NOT MODIFY