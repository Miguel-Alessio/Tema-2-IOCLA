%include "../include/io.mac"

extern printf
global fix_lap_times

section .data
	; optionally, add debug formats here

section .text

; function signature: 
; void fix_lap_times(unsigned int *input_times, char *errors, int num_drivers,
;                    unsigned int *output_times, int *error_count);
; rdi = input_times
; rsi = errors
; rdx = num_drivers
; rcx = output_times
; r8  = error_count

fix_lap_times:
	;; DO NOT MODIFY
	push    rbp
	mov     rbp, rsp
	push    rbx
	push    r12
	push    r13
	push    r14
	push    r15
	;; DO NOT MODIFY

	;; Your code starts here

	;; Your code ends here

	;; DO NOT MODIFY
	pop     r15
	pop     r14
	pop     r13
	pop     r12
	pop     rbx
	pop     rbp
	ret
	;; DO NOT MODIFY
