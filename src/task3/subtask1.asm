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
endstruc

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
	;we add to 'al' the time of departure in minutes
	movzx eax,byte[rdi+34]
	;we set the carry 'edx' to 0
	mov edx,0
	;we add the delay in minutes
	add eax, r8d
	;we verify if
	cmp eax,59
	jle save_minutes

correction_minutes:
	sub eax,60
	mov edx,1

save_minutes:
	mov byte[rdi+34],al

	;we add the departure time in hours to 'eax'
	movzx eax,byte[rdi+33]
	add eax,r9d
	add eax,edx
	mov edx,0
	cmp eax,23
	jle save_hours
correction_hours:
	sub eax,24
	mov edx,1
save_hours:
	mov byte[rdi+33],al

	movzx eax,byte[rdi+32]
	add eax,edx
	mov byte[rdi+32],al

	;we add to r8d the delay minutes
	movzx r8d, byte[rdi+40]
	;we add to r9d the delay delay hours
	movzx r9d,byte[rdi+41]
	;we add to 'al' the time of arival in minutes
	movzx eax,byte[rdi+37]
	;we set the carry 'edx' to 0
	mov edx,0
	;we add the delay in minutes
	add eax, r8d
	cmp eax,59
	jle save_arr_minutes

correction_arr_minutes:
	sub eax,60
	mov edx,1

save_arr_minutes:
	mov byte[rdi+37],al

	;we add the arrival time in hours to 'eax'
	movzx eax,byte[rdi+36]
	add eax,r9d
	add eax,edx
	mov edx,0
	cmp eax,23
	jle save_arr_hours
correction_arr_hours:
	sub eax,24
	mov edx,1
save_arr_hours:
	mov byte[rdi+36],al

	movzx eax,byte[rdi+35]
	add eax,edx
	mov byte[rdi+35],al
	add rdi,42
	dec esi
	jnz flight_loop
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
