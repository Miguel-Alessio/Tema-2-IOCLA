; write the structure
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
global sort_and_return

; int sort_and_return(struct flight* flights, int nrFlights, 
;                      struct flight* bestFlight, char destination[32])
; rdi = flights (pointer)
; rsi = nrFlights (value)
; rdx = bestFlight (pointer to pre-allocated struct)
; rcx = destination (pointer to 32-byte string)
sort_and_return:
	push rbp
	mov rbp, rsp
	push rbx
	push r12
	push r13
	push r14
	push r15
	;; DO NOT MODIFY
	;; Your code starts here
	mov r13,rdx
	mov r14,rcx
	mov r15,rdi

	;we check if there is only 1 flight
	cmp rsi,1
	jle search_destination

	;we copy the number of flights
	mov r8d,esi
ext_loop:
	;we initialize the swap flag with 0
	mov r12d,0
	mov rbx,r15
	;we copy the number of flights for the inner loop
	mov r9d,esi
	dec r9d
inner_loop:
	movzx eax,byte[rbx+35];A flight day
	movzx edx,byte[rbx+35+42];B flight day
	cmp eax,edx
	jg swap_flights
	jl no_swap
	movzx eax,byte[rbx+36];A flight hour
	movzx edx,byte[rbx+36+42];B flight hour
	cmp eax,edx
	jg swap_flights
	jl no_swap
	movzx eax,byte[rbx+37];A flight minute
	movzx edx,byte[rbx+37+42];B flight minute
	cmp eax,edx
	jg swap_flights
	jl no_swap
	movzx eax,word[rbx+38];A flight luggage weight
	movzx edx,word[rbx+38+42];B flight luggage weight
	cmp eax,edx
	jl swap_flights
	jmp no_swap
swap_flights:
	;we set the swap flag to 1
	mov r12d,1
	push qword[rbx]
	;we get the first 8 bytes of the second flight (offset 42)
	mov rax,[rbx+42]
	mov [rbx],rax

	;we pop the first 8 bytes into the second flight (offset 42)
	pop qword[rbx+42]
	;we push the next 8 bytes (offset 8)
	push qword [rbx + 8]
	;we get the next 8 bytes of the second flight (offset 42 + 8)
	mov rax, [rbx + 42 + 8]
	;we move them to the first flight (offset 8)
	mov [rbx + 8], rax
	;we pop the next 8 bytes into the second flight (offset 42 + 8)
	pop qword [rbx + 42 + 8]
	;we push the next 8 bytes (offset 16)
	push qword [rbx + 16]
	;we get the next 8 bytes of the second flight (offset 42 + 16)
	mov rax, [rbx + 42 + 16]
	;we move them to the first flight (offset 16)
	mov [rbx + 16], rax
	;we pop the next 8 bytes into the second flight (offset 42 + 16)
	pop qword [rbx + 42 + 16]
	;we push the next 8 bytes (offset 24)
	push qword [rbx + 24]
	;we get the next 8 bytes of the second flight (offset 42 + 24)
	mov rax, [rbx + 42 + 24]
	;we move them to the first flight (offset 24)
	mov [rbx + 24], rax
	;we pop the next 8 bytes into the second flight (offset 42 + 24)
	pop qword [rbx + 42 + 24]
	;we push the next 8 bytes (offset 32)
	push qword [rbx + 32]
	;we get the next 8 bytes of the second flight (offset 42 + 32)
	mov rax, [rbx + 42 + 32]
	;we move them to the first flight (offset 32)
	mov [rbx + 32], rax
	;we pop the next 8 bytes into the second flight (offset 42 + 32)
	pop qword [rbx + 42 + 32]
	;we push the last 2 bytes (offset 40)
	push word [rbx + 40]
	;we get the last 2 bytes of the second flight (offset 42 + 40)
	mov ax, [rbx + 42 + 40]
	;we move them to the first flight (offset 40)
	mov [rbx + 40], ax
	;we pop the last 2 bytes into the second flight (offset 42 + 40)
	pop word [rbx + 42 + 40]
no_swap:
	;we advance the pointer by the size of the structure (42 bytes)
	add rbx,42
	dec r9d
	jnz inner_loop
	test r12d,r12d
	jz search_destination
	dec r8d
	jnz ext_loop
search_destination:
	mov r8d,esi
	mov rdi,r15
find_loop:
	test r8d,r8d
	jz not_found
	;we initialize the string contor with 0
	mov rcx,0
check_string:
	mov al,[rdi+rcx]
	cmp al,[r14+rcx]
	jne next_flight
	inc rcx
	;we check if we reached the string size limit (32 bytes)
	cmp rcx,32
	jl check_string
	mov rax, [rdi]
	mov [r13], rax
	;we copy the next 8 bytes (offset 8)
	mov rax, [rdi + 8]
	;we move them to bestFlight (offset 8)
	mov [r13 + 8], rax
	;we copy the next 8 bytes (offset 16)
	mov rax, [rdi + 16]
	;we move them to bestFlight (offset 16)
	mov [r13 + 16], rax
	;we copy the next 8 bytes (offset 24)
	mov rax, [rdi + 24]
	;we move them to bestFlight (offset 24)
	mov [r13 + 24], rax
	;we copy the next 8 bytes (offset 32)
	mov rax, [rdi + 32]
	;we move them to bestFlight (offset 32)
	mov [r13 + 32], rax
	;we copy the last 2 bytes (offset 40)
	mov ax, [rdi + 40]
	;we move them to bestFlight (offset 40)
	mov [r13 + 40], ax
	;we return 1 for success
	mov rax,1
	jmp finish
next_flight:
	;we skip to the next flight by adding 42 bytes
	add rdi,42
	dec r8d
	jnz find_loop
not_found:
	;we return 0 for failure
	mov rax,0
finish:	
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