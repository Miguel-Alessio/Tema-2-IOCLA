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
	;we add to r8d the delay minutes (offset 40)
	movzx r8d, byte[rdi+40]
	;we add to r9d the delay hours (offset 41)
	movzx r9d,byte[rdi+41]
	;we add to 'al' the time of departure in minutes (offset 34)
	movzx eax,byte[rdi+34]
	;we set the carry 'edx' to 0
	mov edx,0
	;we add the delay in minutes
	add eax, r8d
	;we verify if it surpases one hour (59 minutes max)
	cmp eax,59
	jle save_minutes

correction_minutes:
	;we substract 60 minutes
	sub eax,60
	;we set the flag to 1, because we later have to add the hour
	mov edx,1

save_minutes:
	;we save the updated departure minutes (offset 34)
	mov byte[rdi+34],al

	;we add the departure time in hours to 'eax' (offset 33)
	movzx eax,byte[rdi+33]
	add eax,r9d
	add eax,edx
	;we reset the carry 'edx' to 0
	mov edx,0
	;we verify if it surpases one day (23 hours max)
	cmp eax,23
	jle save_hours
correction_hours:
	;we substract 24 hours
	sub eax,24
	;we set the flag to 1, because we later have to add the day
	mov edx,1
save_hours:
	;we save the updated departure hours (offset 33)
	mov byte[rdi+33],al

	;we add the departure day to 'eax' (offset 32)
	movzx eax,byte[rdi+32]
	add eax,edx
	;we save the updated departure day (offset 32)
	mov byte[rdi+32],al

	;we add to r8d the delay minutes (offset 40)
	movzx r8d, byte[rdi+40]
	;we add to r9d the delay hours (offset 41)
	movzx r9d,byte[rdi+41]
	;we add to 'al' the time of arival in minutes (offset 37)
	movzx eax,byte[rdi+37]
	;we set the carry 'edx' to 0
	mov edx,0
	;we add the delay in minutes
	add eax, r8d
	;we verify if it surpases one hour (59 minutes max)
	cmp eax,59
	jle save_arr_minutes

correction_arr_minutes:
	;we substract 60 minutes
	sub eax,60
	;we set the flag to 1, because we later have to add the hour
	mov edx,1

save_arr_minutes:
	;we save the updated arrival minutes (offset 37)
	mov byte[rdi+37],al

	;we add the arrival time in hours to 'eax' (offset 36)
	movzx eax,byte[rdi+36]
	add eax,r9d
	add eax,edx
	;we reset the carry 'edx' to 0
	mov edx,0
	;we verify if it surpases one day (23 hours max)
	cmp eax,23
	jle save_arr_hours
correction_arr_hours:
	;we substract 24 hours
	sub eax,24
	;we set the flag to 1, because we later have to add the day
	mov edx,1
save_arr_hours:
	;we save the updated arrival hours (offset 36)
	mov byte[rdi+36],al

	;we add the arrival day to 'eax' (offset 35)
	movzx eax,byte[rdi+35]
	add eax,edx
	;we save the updated arrival day (offset 35)
	mov byte[rdi+35],al
	;we skip to the next flight by adding 42 bytes
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