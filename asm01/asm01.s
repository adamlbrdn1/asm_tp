global _start
section .text

_start:
	mov rax, 0x1
	mov rdi, 1
	mov rsi, message
	mov rdx, message_len
	syscall

	
	mov rax, 0x3c
	xor rdi, rdi
	syscall

section .data
	message db '1337', 0xA
	message_len equ $ - message
