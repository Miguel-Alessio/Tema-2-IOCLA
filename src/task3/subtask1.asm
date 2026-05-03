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
	; we check if there are any flights to process
	cmp rsi, 0
	je end_delay

flight_loop:
	; we add to r8d the delay minutes (offset 40)
	movzx r8d, byte [rdi+40]
	; we add to r9d the delay hours (offset 41)
	movzx r9d, byte [rdi+41]
	; we add to eax the time of arrival in minutes (offset 37)
	movzx eax, byte [rdi+37]
	; we add the delay in minutes
	add eax, r8d
	; we initialize the carry for hours with 0
	mov r10d, 0
	; 59 is the maximum valid value for minutes
	cmp eax, 59
	jle arrival_min_ok
	; 60 is the number of minutes in an hour
	sub eax, 60
	; 1 represents the hour carry
	mov r10d, 1

arrival_min_ok:
	; we save the updated arrival minutes (offset 37)
	mov byte [rdi+37], al
	; we add the arrival time in hours to eax (offset 36)
	movzx eax, byte [rdi+36]
	; we add the delay hours
	add eax, r9d
	; we add the carry from minutes
	add eax, r10d
	; we initialize the carry for days with 0
	mov r10d, 0
	; 23 is the maximum valid value for hours
	cmp eax, 23
	jle arrival_hr_ok
	; 24 is the number of hours in a day
	sub eax, 24
	; 1 represents the day carry
	mov r10d, 1

arrival_hr_ok:
	; we save the updated arrival hours (offset 36)
	mov byte [rdi+36], al
	; we add the arrival day to eax (offset 35)
	movzx eax, byte [rdi+35]
	; we add the carry from hours
	add eax, r10d
	; we save the updated arrival day (offset 35)
	mov byte [rdi+35], al

	; we add to eax the time of departure in minutes (offset 34)
	movzx eax, byte [rdi+34]
	; we add the delay in minutes
	add eax, r8d
	; we initialize the carry for hours with 0
	mov r10d, 0
	; 59 is the maximum valid value for minutes
	cmp eax, 59
	jle departure_min_ok
	; 60 is the number of minutes in an hour
	sub eax, 60
	; 1 represents the hour carry
	mov r10d, 1

departure_min_ok:
	; we save the updated departure minutes (offset 34)
	mov byte [rdi+34], al
	; we add the departure time in hours to eax (offset 33)
	movzx eax, byte [rdi+33]
	; we add the delay hours
	add eax, r9d
	; we add the carry from minutes
	add eax, r10d
	; we initialize the carry for days with 0
	mov r10d, 0
	; 23 is the maximum valid value for hours
	cmp eax, 23
	jle departure_hr_ok
	; 24 is the number of hours in a day
	sub eax, 24
	; 1 represents the day carry
	mov r10d, 1

departure_hr_ok:
	; we save the updated departure hours (offset 33)
	mov byte [rdi+33], al
	; we add the departure day to eax (offset 32)
	movzx eax, byte [rdi+32]
	; we add the carry from hours
	add eax, r10d
	; we save the updated departure day (offset 32)
	mov byte [rdi+32], al

	; 42 is the size in bytes of the flight structure
	add rdi, 42
	dec rsi
	jnz flight_loop

end_delay:
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