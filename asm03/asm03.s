global _start

section .bss
    input resb 2

section .data
    msg: db "1337", 01
    .len: equ $ - msg

section .text
_start:

    mov rsi, rsp        
    add rsi, 16        
    mov rsi, [rsi]    
    mov rdi, input   
    mov rcx, 4      
    rep movsb      

    mov al, [input]
    cmp al, '4'
    jne _error

    mov al, [input + 1]
    cmp al, '2'
    jne _error

    mov al, [input + 2]
    cmp al, 0
    jne _error

_exit:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, msg.len
    syscall

    mov rax, 60
    mov rdi, 0
    syscall

_error:
    mov rax, 60
    mov rdi, 1
    syscall
