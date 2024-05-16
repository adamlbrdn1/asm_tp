global _start

section .bss
    input resb 32  ; Réservation de 32 octets pour l'entrée utilisateur

section .text
_start:

    ; Lecture de l'entrée utilisateur
    mov rax, 0      ; Code syscall pour sys_read
    mov rdi, 0      ; Descripteur de fichier stdin
    mov rsi, input  ; Pointeur vers l'emplacement où stocker l'entrée
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
    ; Calcul de la somme des nombres entiers strictement inférieurs à la valeur donnée
    xor rdi, rdi       ; Réinitialisation de RDI à zéro pour utilisation future
    xor rax, rax       ; Réinitialisation de RAX à zéro
    mov rcx, 1         ; Initialise le compteur à 1
sum_loop:
    cmp rcx, r8        ; Compare le compteur avec la valeur donnée
    jg sum_done        ; Si le compteur est supérieur à la valeur, terminer
    add rax, rcx       ; Ajoute le compteur à la somme
    inc rcx            ; Incrémente le compteur
    jmp sum_loop       ; Boucle pour le prochain nombre

sum_done:
    ; Affichage de la somme calculée
    mov rax, 1         ; Code syscall pour sys_write
    mov rdi, 1         ; Descripteur de fichier stdout
    mov rsi, rax       ; Adresse de la somme à afficher
    mov rdx, 10        ; Longueur de la somme (1 byte pour le caractère de nouvelle ligne)
    syscall

    ; Sortie du programme
    mov rax, 60        ; Code syscall pour sys_exit
    xor rdi, rdi       ; Code de retour 0
    syscall

error:
    ; Gestion des erreurs
    mov rax, 60        ; Code syscall pour sys_exit
    mov rdi, 1         ; Code de retour 1 pour les erreurs
    syscall

