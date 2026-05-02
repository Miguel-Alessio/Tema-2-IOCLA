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
	mov r8d, dword [rdx];number of flights
	mov r9d,0
	mov r11,rdx
filter_loop:
	cmp r8d,0
	je end_filter
	movzx r10d,word[rdi+38]
	cmp r10d,ecx
	jl skip_flight
	mov rax, [rdi]
    mov [rsi], rax
    mov rax, [rdi + 8]
    mov [rsi + 8], rax
    mov rax, [rdi + 16]
    mov [rsi + 16], rax
    mov rax, [rdi + 24]
    mov [rsi + 24], rax
	;we copy the rest of bytes
    mov rax, [rdi + 32]
    mov [rsi + 32], rax
	;we move the last 2 bytes
    mov ax, [rdi + 40]
    mov [rsi + 40], ax
	inc r9d
	add rsi,42
skip_flight:
	add rdi,42
	dec r8d
	jnz filter_loop
end_filter:
	mov dword[r11],r9d
	

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

	leave
	ret