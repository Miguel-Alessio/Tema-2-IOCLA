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
	mov r13, rdx
	mov r14, rcx
	mov r15, rdi

	; 1 represents a single flight
	cmp rsi, 1
	jle search_destination
	; we use selection sort to minimize swaps
	; 0 is the starting index for the outer loop
	mov r8d, 0

ext_loop:
	; r9d will be the inner loop counter (starts from r8d + 1)
	mov r9d, r8d
	inc r9d
	; we check if outer loop reached the end
	mov eax, esi
	dec eax
	cmp r8d, eax
	jge search_destination
	; we assume the current position (r8d) is the best (minimum)
	mov r10d, r8d

inner_loop:
	; we check if inner loop reached the end
	cmp r9d, esi
	jge do_swap_if_needed
	; 42 is the size in bytes of the flight structure
	mov eax, 42
	mul r10d
	; r11 will hold the pointer to the currently best flight
	lea r11, [r15 + rax]
	; 42 is the size in bytes of the flight structure
	mov eax, 42
	mul r9d
	; rbx will hold the pointer to the candidate flight
	lea rbx, [r15 + rax]
	; 35 is the offset for the departure day
	movzx eax, byte [r11 + 35]
	; 35 is the offset for the departure day
	movzx edx, byte [rbx + 35]
	cmp eax, edx
	jg found_better
	jl check_next
	; 36 is the offset for the departure hour
	movzx eax, byte [r11 + 36]
	; 36 is the offset for the departure hour
	movzx edx, byte [rbx + 36]
	cmp eax, edx
	jg found_better
	jl check_next
	; 37 is the offset for the departure minute
	movzx eax, byte [r11 + 37]
	; 37 is the offset for the departure minute
	movzx edx, byte [rbx + 37]
	cmp eax, edx
	jg found_better
	jl check_next
	; 38 is the offset for the bag weight
	movzx eax, word [r11 + 38]
	; 38 is the offset for the bag weight
	movzx edx, word [rbx + 38]
	cmp eax, edx
	jl found_better
	jmp check_next

found_better:
	; we update the index of the best flight found so far
	mov r10d, r9d

check_next:
	inc r9d
	jmp inner_loop

do_swap_if_needed:
	; we check if the best flight is already in the right place
	cmp r8d, r10d
	je advance_ext
	; 42 is the size in bytes of the flight structure
	mov eax, 42
	mul r8d
	lea rbx, [r15 + rax]
	; 42 is the size in bytes of the flight structure
	mov eax, 42
	mul r10d
	lea r11, [r15 + rax]
	push qword [rbx]
	mov rax, [r11]
	mov [rbx], rax
	pop qword [r11]
	; 8 is the offset for the next 8 bytes
	push qword [rbx + 8]
	; 8 is the offset for the next 8 bytes
	mov rax, [r11 + 8]
	; 8 is the offset for the next 8 bytes
	mov [rbx + 8], rax
	; 8 is the offset for the next 8 bytes
	pop qword [r11 + 8]
	; 16 is the offset for the next 8 bytes
	push qword [rbx + 16]
	; 16 is the offset for the next 8 bytes
	mov rax, [r11 + 16]
	; 16 is the offset for the next 8 bytes
	mov [rbx + 16], rax
	; 16 is the offset for the next 8 bytes
	pop qword [r11 + 16]
	; 24 is the offset for the next 8 bytes
	push qword [rbx + 24]
	; 24 is the offset for the next 8 bytes
	mov rax, [r11 + 24]
	; 24 is the offset for the next 8 bytes
	mov [rbx + 24], rax
	; 24 is the offset for the next 8 bytes
	pop qword [r11 + 24]
	; 32 is the offset for the next 8 bytes
	push qword [rbx + 32]
	; 32 is the offset for the next 8 bytes
	mov rax, [r11 + 32]
	; 32 is the offset for the next 8 bytes
	mov [rbx + 32], rax
	; 32 is the offset for the next 8 bytes
	pop qword [r11 + 32]
	; 40 is the offset for the last 2 bytes
	push word [rbx + 40]
	; 40 is the offset for the last 2 bytes
	mov ax, [r11 + 40]
	; 40 is the offset for the last 2 bytes
	mov [rbx + 40], ax
	; 40 is the offset for the last 2 bytes
	pop word [r11 + 40]

advance_ext:
	inc r8d
	jmp ext_loop


search_destination:
	mov r8d, esi
	mov rdi, r15

find_loop:
	; 0 represents no flights left to check
	cmp r8d, 0
	je not_found
	; 31 is the last index of the string to break patterns
	mov rcx, 31

check_string_reverse:
	mov al, [rdi + rcx]
	cmp al, [r14 + rcx]
	jne next_flight
	dec rcx
	; 0 is the first index of the string
	cmp rcx, 0
	jge check_string_reverse
	mov rax, [rdi]
	mov [r13], rax
	; 8 is the offset for the next 8 bytes
	mov rax, [rdi + 8]
	; 8 is the offset for the next 8 bytes
	mov [r13 + 8], rax
	; 16 is the offset for the next 8 bytes
	mov rax, [rdi + 16]
	; 16 is the offset for the next 8 bytes
	mov [r13 + 16], rax
	; 24 is the offset for the next 8 bytes
	mov rax, [rdi + 24]
	; 24 is the offset for the next 8 bytes
	mov [r13 + 24], rax
	; 32 is the offset for the next 8 bytes
	mov rax, [rdi + 32]
	; 32 is the offset for the next 8 bytes
	mov [r13 + 32], rax
	; 40 is the offset for the last 2 bytes
	mov ax, [rdi + 40]
	; 40 is the offset for the last 2 bytes
	mov [r13 + 40], ax
	; 1 represents success
	mov rax, 1
	jmp finish

next_flight:
	; 42 is the size in bytes of the flight structure
	add rdi, 42
	dec r8d
	jmp find_loop

not_found:
	; 0 represents failure
	mov rax, 0

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