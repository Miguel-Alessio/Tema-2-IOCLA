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
	cmp rsi,1
	jle search_destination

	mov r8d,esi;exterior limit
ext_loop:
	mov r12d,0;swaps_made=false
	mov rcx,r15;start address of the array
	mov r9d,esi;contor
	dec r9d
inner_loop:
	movzx eax,byte[rbx+35];A flight day
	movzx edx,byte[rbx+35+42];B flight day
	cmp eax,edx
	jg swap_flights
	jl no_swap
	movzx eax,byte[rbx+36];A flight hour
	movzx edx,byte[rbx+36+42];B flight hour
	cmp rax,edx
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
	mov r12d,1;swap made, flag set to 1
	push qword[rbx]
	mov rax,[rbx+42]
	mov [rbx],rax
	pop qword[rbx+42]

	push qword [rbx + 8]
    mov rax, [rbx + 42 + 8]
    mov [rbx + 8], rax
    pop qword [rbx + 42 + 8]

	push qword [rbx + 16]
    mov rax, [rbx + 42 + 16]
    mov [rbx + 16], rax
    pop qword [rbx + 42 + 16]

	push qword [rbx + 24]
    mov rax, [rbx + 42 + 24]
    mov [rbx + 24], rax
    pop qword [rbx + 42 + 24]

	push qword [rbx + 32]
    mov rax, [rbx + 42 + 32]
    mov [rbx + 32], rax
    pop qword [rbx + 42 + 32]

	push word [rbx + 40]
    mov ax, [rbx + 42 + 40]
    mov [rbx + 40], ax
    pop word [rbx + 42 + 40]
	
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