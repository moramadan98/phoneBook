section  .data

msgMain db 13,10,"Choose one of the following Option by enter the option number  ",13,10,"1- Add new contact",13,10,"2- Display all contacts",13,10,"3- Search in contacts",13,10,"4- Add number to existing contact",13,10,"5- Delete one number from contact",13,10,"6- Delete contact ",13,10,">>", 0
lenmsgMain equ $ - msgMain  

msgEnterAddContact db "[!] Enter new contact Name ", 13, 10,">>",0
lenmsgEnterAddContact equ $ - msgEnterAddContact

msgEnterDisplay db "[^_^] Contacts ", 13, 10,0
lenmsgEnterDisplay equ $ - msgEnterDisplay

msgNumberDisplay db "[^_^] Numbers ", 13, 10,0
lenmsgNumberDisplay equ $ - msgNumberDisplay


msgEnterSearch db "[!] Enter the name you want to search for ", 13, 10,">>",0
lenmsgEnterSearch equ $ - msgEnterSearch

msgEnterAddNumber db "[!] Enter the name you want to add new number for it ", 13, 10,">>", 0
lenmsgEnterAddNumber equ $ - msgEnterAddNumber

msgEnterDeleteNumber db "[!] Enter the name you want to delete number from it " , 13, 10,">>", 0
lenmsgEnterDeleteNumber equ $ - msgEnterDeleteNumber


msgContDeleteNumber db "[!] Choose which number you want to delete by index of number " , 13, 10,">>", 0
lenmsgContDeleteNumber equ $ - msgContDeleteNumber

msgEnterDeleteContact db "[!] Enter contact Name which you want to delete " , 13, 10 ,0
lenmsgEnterDeleteContact equ $ - msgEnterDeleteContact

msgDisplayDone db 13, 10, "[^_^] Done ", 13, 10,13, 10,13, 10,0
lenmsgDisplayDone equ $ - msgDisplayDone


msgNotfoundError db 13, 10, "[X] Not Found ", 13, 10,0
lenmsgNotfoundError equ $ - msgNotfoundError

msgEnterError db 13, 10, "[X] Invalid input ", 13, 10,0
lenmsgEnterError equ $ - msgEnterError



section .bss
   user_input resb 1    ; user input
   user_input_length equ $- user_input
   
   

section .text
    global _start
_start:

   ;write
         mov  rax, 4             ; sys_write
         mov  rbx, 1             ; stdout
         mov  rcx, msgMain           ; buffer
         mov  rdx, lenmsgMain          ; length
         int  80h
   ;read
         mov  rax, 3 ; sys_read
         mov  rbx, 0 ; stdin
         mov  rcx, user_input ; user input
         mov  rdx, user_input_length ; max length
         int  80h
     
   
   ;input to string converter function     
         mov esi, user_input
         mov ecx,1
         call string_to_int          
         


   ;comp
                                                                     
         cmp eax,1
         je  _AddContact
            
         cmp eax,2
         je  _Display
    
         cmp eax,3
         je  _Search
    
         cmp eax,4
         je  _AddNumber
    
         cmp eax,5
         je  _DeleteNumber
    
         cmp eax,6
         je  _DeleteContact
         
         
   ;end      
         mov    rax, 1
         mov    rbx, 0
         int    80h
         
                    

_AddContact:
  ;write
    mov  rax, 4             ; sys_write
    mov  rbx, 1             ; stdout
    mov  rcx, msgEnterAddContact           ; buffer
    mov  rdx, lenmsgEnterAddContact          ; length
    int  80h
    
    
    call msgDone

_Display:
    mov  rax, 4             ; sys_write
    mov  rbx, 1             ; stdout
    mov  rcx, msgEnterDisplay           ; buffer
    mov  rdx, lenmsgEnterDisplay          ; length
    int  80h
    
    call msgDone
 


_Search:
    mov  rax, 4             ; sys_write
    mov  rbx, 1             ; stdout
    mov  rcx, msgEnterSearch           ; buffer
    mov  rdx, lenmsgEnterSearch          ; length
    int  80h
    
    call msgDone
    

_AddNumber:
    mov  rax, 4             ; sys_write
    mov  rbx, 1             ; stdout
    mov  rcx, msgEnterAddNumber           ; buffer
    mov  rdx, lenmsgEnterAddNumber          ; length
    int  80h
    
    call msgDone
    
_DeleteNumber:
    
    
    mov  rax, 4             ; sys_write
    mov  rbx, 1             ; stdout
    mov  rcx, msgEnterDeleteNumber           ; buffer
    mov  rdx, lenmsgEnterDeleteNumber          ; length
    int  80h
  
    
    
    
    mov  rax, 4             ; sys_write
    mov  rbx, 1             ; stdout
    mov  rcx, msgNumberDisplay           ; buffer
    mov  rdx, lenmsgNumberDisplay          ; length
    int  80h
    
      
    
    mov  rax, 4             ; sys_write
    mov  rbx, 1             ; stdout
    mov  rcx, msgContDeleteNumber           ; buffer
    mov  rdx, lenmsgContDeleteNumber          ; length
    int  80h
    
    call msgDone
    
    
_DeleteContact:
    mov  rax, 4             ; sys_write
    mov  rbx, 1             ; stdout
    mov  rcx, msgEnterDeleteContact           ; buffer
    mov  rdx, lenmsgEnterDeleteContact          ; length
    int  80h
    
    call msgDone
    

msgDone:
    mov  rax, 4             ; sys_write
    mov  rbx, 1             ; stdout
    mov  rcx, msgDisplayDone           ; buffer
    mov  rdx, lenmsgDisplayDone         ; length
    int  80h
    
    call _start
    

    
            
string_to_int:
; Input:
; ESI = pointer to the string to convert
; ECX = number of digits in the string (must be > 0)
; Output:
; EAX = integer value
    xor ebx,ebx    ; clear ebx
.next_digit:
    movzx eax,byte[esi]
    inc esi
    sub al,'0'    ; convert from ASCII to number
    imul ebx,10
    add ebx,eax   ; ebx = ebx*10 + eax
    loop .next_digit  ; while (--ecx)
    mov eax,ebx
    ret
