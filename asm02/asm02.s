section .bss
    input resb 3  

section .data
    msg db "1337", 10  
    msg_len equ $ - msg  

section .text
    global _start

_start:
    mov rax, 0        
    mov rdi, 0        
    mov rsi, input    
    mov rdx, 3        
    syscall

    
    cmp byte [input], '4'
    jne _error
    
    
    cmp byte [input + 1], '2'
    jne _error

    
    cmp byte [input + 2], 10
    jne _error

    
    mov rax, 1        
    mov rdi, 1        
    mov rsi, msg      
    mov rdx, msg_len  
    syscall

   
    mov rax, 60       
    xor rdi, rdi      
    syscall

_error:
    mov rax, 60       
    mov rdi, 1        
    mov rsi, errmsg   
    mov rdx, errmsg_len  
    syscall

    
    mov rax, 60       
    mov rdi, 1        
    syscall

section .data
    errmsg db "Erreur: Entrée incorrecte", 10  
    errmsg_len equ $ - errmsg 

