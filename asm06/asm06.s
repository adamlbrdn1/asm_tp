global _start

section .bss
    input resb 10  ; Réserver de l'espace pour stocker l'entrée

section .text
_start:

    ; Lire l'entrée
    mov rax, 0          ; sys_read
    mov rdi, 0          ; stdin
    mov rsi, input      ; Adresse de stockage
    mov rdx, 10         ; Nombre maximum de caractères à lire
    syscall

    ; Convertir l'entrée en un nombre entier
    xor rax, rax        ; Réinitialiser RAX
    mov rcx, input      ; Pointeur vers le début de la chaîne
.convert_loop:
    movzx rdx, byte [rcx]  ; Charger le caractère
    test rdx, rdx          ; Vérifier la fin de la chaîne
    jz .input_done         ; Si c'est la fin de la chaîne, terminer la conversion
    sub rdx, '0'           ; Convertir ASCII en nombre
    imul rax, rax, 10      ; Multiplier par 10
    add rax, rdx           ; Ajouter le chiffre
    inc rcx                ; Passer au caractère suivant
    jmp .convert_loop      ; Répéter la conversion

.input_done:

    ; Traiter les cas particuliers
    cmp rax, 1
    je _not_prime       ; 1 n'est pas un nombre premier
    cmp rax, 2
    je _prime           ; 2 est un nombre premier

    ; Vérifier si le nombre est pair
    test al, 1               
    jnz _check_divisors                  
    
    ; Si le nombre est pair et différent de 2, il n'est pas premier
    mov rax, 0
    jmp _exit

_check_divisors:
    ; Vérifier les diviseurs jusqu'à la racine carrée du nombre
    mov rdx, 2                ; Commencer par le premier diviseur (2)
.check_divisors_loop:
    mov rsi, rax              ; Sauvegarder le nombre
    xor rax, rax              ; Réinitialiser RAX
    mov rcx, rsi              ; Charger le nombre à diviser
    div rdx                   ; Diviser rsi:rax par rdx (rax = quotient, rdx = reste)
    cmp rdx, 0                ; Vérifier si le reste est nul
    je _not_prime             ; Si oui, le nombre n'est pas premier
    inc rdx                   ; Passer au diviseur suivant
    cmp rdx, rsi              ; Vérifier si nous avons dépassé la racine carrée du nombre
    jg _prime                 ; Si oui, le nombre est premier
    jmp .check_divisors_loop  ; Sinon, continuer la vérification des diviseurs

_prime:
    ; Si le nombre est premier, retourner 1
    mov rax, 1
    jmp _exit

_not_prime:
    ; Si le nombre n'est pas premier, retourner 0
    mov rax, 0
    jmp _exit

_exit:
    ; Terminer le programme
    mov rdi, rax       
    mov rax, 60
    syscall

