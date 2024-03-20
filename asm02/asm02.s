global _start
section .text

_start:
	mov rax, 0
	mov rdi, 0
	mov rsi, input
	mov rdx, 1
	syscall


	movzx rdi, byte [input]
	sub rdi, '0'

	
	cmp rdi, 42
	jne not_42
	

	
	mov rax, 0x1
	mov rdi, 1
	mov rsi, message
	mov rdx message_len
	syscall

	
	mov rax, 0x3c
	mov rdi, 1
	syscall


not_42:
	mov rax, 0x3c
	mov rdi, 1
	syscall


section .data
	message db '1337', 0xA
	message_len equ $ - message 
	input resb 1
