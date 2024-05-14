section .bss
    input resb 2
    param_error_msg db "Erreur : Aucun paramètre fourni", 0Ah
    param_error_len equ $ - param_error_msg

section .data
    msg db "1337", 01
    msg_len equ $ - msg
    error_msg db "1", 01
    error_len equ $ - error_msg
    no_input_msg db "No Input", 0Ah
    no_input_len equ $ - no_input_msg

section .text
global _start

_start:
    mov r13, [rsp]      
    cmp r13, 2            
    jne _param_error     

    cmp r13, 1
    jle _param_error      

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
    mov rdx, msg_len
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

_error:
    mov rax, 1
    mov rdi, 1
    mov rsi, error_msg
    mov rdx, error_len
    syscall

    mov rax, 60
    mov rdi, 1
    syscall

_param_error:
    mov rax, 1
    mov rdi, 1
    mov rsi, param_error_msg
    mov rdx, param_error_len
    syscall

    mov rax, 60
    mov rdi, 1
    syscall
