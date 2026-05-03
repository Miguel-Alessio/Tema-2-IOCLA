; write the structures
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
global filter_flights

; void filter_flights(struct flight* origFlights, struct flight* finalFlights
;						 int* nrFlights, int min_bag_weight)
; rdi = struct flight *origFlights
; rsi = struct flight *finalFlights
; rdx = int *nrFlights
; rcx = int min_bag_weight
filter_flights:
	push rbp
	mov rbp, rsp
	push rbx
	push r12
	push r13
	push r14
	push r15
	;; DO NOT MODIFY
	;; Your code starts here
	; we copy the number of flights from the pointer
	mov r8d, dword [rdx]
	; we initialize the valid flights contor with 0
	mov r9d, 0
	; we save the pointer to nrFlights
	mov r11, rdx

filter_loop:
	; we check if there are 0 flights left to process
	cmp r8d, 0
	je end_filter
	; 38 is the offset for the bag_weight variable
	movzx r10d, word [rdi + 38]
	; we compare the current weight with the minimum weight
	cmp r10d, ecx
	jge copy_valid_flight
	jmp advance_source

copy_valid_flight:
	; we copy the first 8 bytes (destination string start)
	mov r12, [rdi]
	mov [rsi], r12
	; we copy the next 8 bytes (offset 8)
	mov r12, [rdi + 8]
	; we move them to the final array (offset 8)
	mov [rsi + 8], r12
	; we copy the next 8 bytes (offset 16)
	mov r12, [rdi + 16]
	; we move them to the final array (offset 16)
	mov [rsi + 16], r12
	; we copy the next 8 bytes (offset 24)
	mov r12, [rdi + 24]
	; we move them to the final array (offset 24)
	mov [rsi + 24], r12
	; we copy the next 8 bytes (offset 32)
	mov r12, [rdi + 32]
	; we move them to the final array (offset 32)
	mov [rsi + 32], r12
	; we move the last 2 bytes (offset 40)
	mov bx, [rdi + 40]
	; we move them to the final array (offset 40)
	mov [rsi + 40], bx
	inc r9d
	; 42 is the size in bytes of a flight
	add rsi, 42

advance_source:
	; 42 is the size in bytes of a flight
	add rdi, 42
	dec r8d
	jmp filter_loop

end_filter:
	mov dword [r11], r9d
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