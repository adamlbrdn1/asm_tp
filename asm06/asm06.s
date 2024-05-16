global _start

section .bss
    input resb 32  ; Réservation de 32 octets pour l'entrée utilisateur

section .text
_start:

    ; Lecture de l'entrée utilisateur
    mov rax, 0      ; Code syscall pour sys_read
    mov rdi, 0      ; Descripteur de fichier stdin
    mov rsi, input ; Pointeur vers l'emplacement où stocker l'entrée
    mov rdx, 32     ; Nombre maximum d'octets à lire
    syscall

    ; Conversion de la chaîne d'entrée en nombre entier
    mov rdi, 0      ; Indice pour parcourir la chaîne d'entrée
    xor r8, r8      ; Initialise le résultat à zéro
    xor rax, rax    ; Réinitialisation d'AL à zéro
convert_loop:
    mov al, [input + rdi]  ; Charge un caractère de la chaîne d'entrée dans AL
    cmp al, 10             ; Comparaison avec la valeur ASCII de la nouvelle ligne
    je input_done          ; Si c'est une nouvelle ligne, terminer la saisie
    cmp al, '0'            ; Comparaison avec le caractère '0'
    jl error               ; Si c'est inférieur à '0', c'est une erreur
    cmp al, '9'            ; Comparaison avec le caractère '9'
    jg error               ; Si c'est supérieur à '9', c'est une erreur
    sub al, 48             ; Convertit le caractère ASCII en nombre entier
    imul r8, r8, 10        ; Multiplie le résultat actuel par 10
    add r8, rax            ; Ajoute la valeur convertie
    inc rdi                ; Passage au prochain caractère
    jmp convert_loop       ; Boucle pour le prochain caractère

input_done:
    ; Vérification de la primalité du nombre
    xor rdi, rdi       ; Réinitialisation de RDI à zéro pour utilisation future
    xor rax, rax       ; Réinitialisation de RAX à zéro
    mov rcx, 2         ; Débute la vérification à partir de 2

    cmp r8, 1          ; Si le nombre est égal à 1
    je not_prime       ; Il n'est pas premier

    cmp r8, 2          ; Si le nombre est égal à 2
    je prime           ; Il est premier

check_loop:
    xor rdx, rdx       ; Réinitialisation de RDX à zéro
    mov rax, r8        ; Charge le nombre à vérifier dans RAX
    div rcx            ; Divise RAX par RCX, le quotient est stocké dans RAX et le reste dans RDX
    cmp rdx, 0         ; Vérifie si le reste est zéro
    je check           ; Si oui, le nombre n'est pas premier
    inc rcx            ; Passe au prochain nombre pour la vérification
    jmp check_loop    ; Boucle pour le prochain nombre

check:
    cmp rcx, r8        ; Comparaison de RCX avec le nombre d'origine
    je prime           ; Si RCX est égal au nombre d'origine, le nombre est premier
    jne not_prime      ; Sinon, le nombre n'est pas premier

prime:
    ; Si le nombre est premier, retourner 0
    mov rax, 60      ; Code syscall pour sys_exit
    mov rdi, 0       ; Code de retour 0
    syscall

not_prime:
    ; Si le nombre n'est pas premier, retourner 1
    mov rax, 60      ; Code syscall pour sys_exit
    mov rdi, 1       ; Code de retour 1
    syscall

error:
    ; Gestion des erreurs
    mov rax, 60      ; Code syscall pour sys_exit
    mov rdi, 1       ; Code de retour 1 pour les erreurs
    syscall
