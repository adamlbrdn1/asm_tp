global _start

section .bss
    input resb 2

section .data
    msg db "0", 0xA 
    newline db 0xA
    msg_len equ $ - msg
    newline_len equ 1

section .text
_start:

    mov rax, 0          
    mov rdi, 0          
    mov rsi, input      
    mov rdx, 2          
    syscall

  
    movzx eax, byte [input]  
    sub eax, '0'             
    test al, 1               
    jnz _odd                 

_even:
    
    mov rax, 60
    xor rdi, rdi
    syscall

_odd:
    mov byte [msg], '1'  
    jmp _print_result

_print_result:
    
    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, msg_len
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall
