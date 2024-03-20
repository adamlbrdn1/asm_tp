global  _start
section .text

_start:
	mov rax, 0x3c
	mov rdi, 0x0
	syscall
