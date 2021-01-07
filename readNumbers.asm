section .data
filename db 'me.txt', 0h 



section   .bss
fileContents resb 1024,          ; variable to store file conten
    
    
    section .text
global main
main:

    
    
 
    mov     ecx, 0              
    mov     ebx, filename
    mov     eax, 5
    int     80h
    
    
     mov     edx, 1024             
    mov     ecx, fileContents   
    mov     ebx, eax            
    mov     eax, 3              
    int     80h      
    
    
     mov eax, 4
   mov ebx, 1
   mov ecx, fileContents
   mov edx, 1024
   int  0x80
    
    
    
