; write the structures. make sure it fits the layour in the README
struc flight
	.destination: resb 32
	.depart_day: resb 1
	.depart_hour: resb 1
	.depart_minutes: resb 1
	.arrival_day: resb 1
	.arrival_hour: resb 1
	.arrival_minute: resb 1
	.bag_weight: resw 1
	.delay_minutes: resb 1
	.delay_hours: resb 1
endtruc

section .text
;; DO NOT MODIFY
global apply_delay

; void apply_delay(struct flight* flights, int nrFlights)
; rdi = struct flight *flightss
; rsi = int nrFlights
apply_delay:
	push rbp
	mov rbp, rsp
	push rbx
	push r12
	push r13
	push r14
	push r15
	;; DO NOT MODIFY
	;; Your code starts here
flight_loop:
	;we add to r8d the delay minutes
	movzx r8d, byte[rdi+40]
	;we add to r9d the delay delay hours
	movzx r9d,byte[rdi+41]
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
