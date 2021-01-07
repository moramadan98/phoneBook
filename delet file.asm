
 
SECTION .data
filename db 'me.txt', 0h    ; the filename to delete
 
SECTION .text
global  main
 
main:
 
    mov     ebx, filename       
    mov     eax, 10             
    int     80h                 
 
   