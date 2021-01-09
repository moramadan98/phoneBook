section  .data

msgMain db 13,10,"Choose one of the following Option by enter the option number  ",13,10,"1- Add new contact",13,10,"2- Display all contacts",13,10,"3- Search in contacts",13,10,"4- Add number to existing contact",13,10,"5- Delete one number from contact",13,10,"6- Delete contact ",13,10,"0- Exit ",13,10,">>", 0

lenmsgMain equ $ - msgMain  

msgEnterAddContact db "[!] Enter new contact Name ", 13, 10,">>",0
lenmsgEnterAddContact equ $ - msgEnterAddContact



msgEnterDisplay db "[^_^] Contacts ", 13, 10,0
lenmsgEnterDisplay equ $ - msgEnterDisplay

msgNumberDisplay db "[^_^] Numbers ", 13, 10,0
lenmsgNumberDisplay equ $ - msgNumberDisplay


msgEnterSearch db "[!] Enter the name you want to search for ", 13, 10,">>",0
lenmsgEnterSearch equ $ - msgEnterSearch

msgEnterNumber2 db "[!] Enter the name you want to add new number for it ", 13, 10,">>", 0
lenmsgEnterNumber2 equ $ - msgEnterNumber2

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

msgEnterNumber db 13, 10, "[!] Enter Number :  ", 13, 10,0
lenmsgEnterNumber equ $ - msgEnterNumber

ContactsFile db "contacts.txt" ,0

newline db 0ah





section .bss
   user_input resb 2    ; user input
   user_input_length equ $- user_input
   
   Cname  resb 20
   Cname_len equ $ - Cname
   
   Cnum   resb 20
   Cnum_len equ $ - Cnum
   
   loadedFile resb 1024
   loadedFile_len equ $ - loadedFile
   
   

section .text
    global main
 main:
  
 loop:  

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
         int 80h
        
         
         


   ;comp
                                                                     
         cmp byte [rcx],49
         
         je  _AddContact
            
         cmp byte [rcx],50
         je  _Display
    
         cmp byte [rcx] ,51
         je  _Search
    
         cmp byte [rcx],52
         je  _AddNumber
    
         cmp byte [rcx],53
         je  _DeleteNumber
    
         cmp byte [rcx],54
         je  _DeleteContact
         
         cmp byte [rcx],48
         je exit
     
     end:
          jmp loop   
        
        
_AddContact:
  
    mov rsi ,msgEnterAddContact
    mov rdx ,lenmsgEnterAddContact
    call _print;(rsi = &Buffer, rdx = &len)
    
    mov rsi ,Cname
    mov rdx ,Cname_len  
    call _inputWithLength;(rsi = &Buffer, rdx = &len)://rcx = len of input message, Buffer = input
    
    mov rbx ,Cname
    call _clearLastChar;(rbx = &Buffer,rcx = len)
    
    mov rdx ,rcx
    mov rbx , ContactsFile
    mov rcx ,Cname
    call _appendInFile;(rbx = &FileName, rcx = &msg, rdx = Number of Bytes)://rax = [file_descriptor] 
    
     mov rdx ,1
    mov rbx , ContactsFile
    mov rcx ,newline
    call _appendInFile;(rbx = &FileName, rcx = &msg, rdx = Number of Bytes)://rax = [file_descriptor] 
    
     mov rbx , Cname
     call  _createFile;(rbx = &FileName)://rax = [file_descriptor]
     
     mov rsi ,msgEnterNumber
    mov rdx ,lenmsgEnterNumber
    call _print;(rsi = &Buffer, rdx = &len)
    
    mov rsi ,Cnum
    mov rdx ,Cnum_len  
    call _inputWithLength;(rsi = &Buffer, rdx = &len)://rcx = len of input message, Buffer = input
    
  ; mov rbx ,Cnum
   ; call _clearLastChar;(rbx = &Buffer,rcx = len)
    
    mov rdx ,rcx
    mov rbx , Cname
    mov rcx ,Cnum
    call _appendInFile;(rbx = &FileName, rcx = &msg, rdx = Number of Bytes)://rax = [file_descriptor] 
    
    
    
     mov rbx , Cname
    call _clearBuffer;(rbx = &Buffer)
    
     mov rbx , Cnum
    call _clearBuffer;(rbx = &Buffer)
    
    jmp msgDone
    




_Display:
    mov  rax, 4             ; sys_write
    mov  rbx, 1             ; stdout
    mov  rcx, msgEnterDisplay           ; buffer
    mov  rdx, lenmsgEnterDisplay          ; length
    int  80h
    
    mov rbx ,ContactsFile
    mov rdi , loadedFile
    call  _readFile;(rbx = &FileName , rdi =&loadedFile )://rax = [file_descriptor]
    
     mov rsi,loadedFile
     mov rdx,loadedFile_len 
    call _print;(rsi = &Buffer, rdx = &len)
    
    
    
    jmp msgDone
 


_Search:
    mov  rax, 4             ; sys_write
    mov  rbx, 1             ; stdout
    mov  rcx, msgEnterSearch           ; buffer
    mov  rdx, lenmsgEnterSearch          ; length
    int  80h
    jmp msgDone
    

_AddNumber:
   
    mov rsi ,msgEnterNumber2
    mov rdx ,lenmsgEnterNumber2
    call _print;(rsi = &Buffer, rdx = &len)
    
    mov rsi ,Cname
    mov rdx ,Cname_len  
    call _inputWithLength;(rsi = &Buffer, rdx = &len)://rcx = len of input message, Buffer = input
    
    mov rbx ,Cname
    call _clearLastChar;(rbx = &Buffer,rcx = len)
    
    mov rsi ,msgEnterNumber
    mov rdx ,lenmsgEnterNumber
    call _print;(rsi = &Buffer, rdx = &len)
    
    mov rsi ,Cnum
    mov rdx ,Cnum_len  
    call _inputWithLength;(rsi = &Buffer, rdx = &len)://rcx = len of input message, Buffer = input
    
    ;mov rbx ,Cnum
    ;call _clearLastChar;(rbx = &Buffer,rcx = len)
    
     mov rdx ,rcx
    mov rbx , Cname
    mov rcx ,Cnum
    call _appendInFile;(rbx = &FileName, rcx = &msg, rdx = Number of Bytes)://rax = [file_descriptor] 
    
    ;mov rdx ,1
    ;mov rbx , Cname
    ;mov rcx ,newline
    ;call _appendInFile;(rbx = &FileName, rcx = &msg, rdx = Number of Bytes)://rax = [file_descriptor] 
    
    jmp msgDone
    
    
    
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
    jmp msgDone
    
    
_DeleteContact:
    mov  rax, 4             ; sys_write
    mov  rbx, 1             ; stdout
    mov  rcx, msgEnterDeleteContact           ; buffer
    mov  rdx, lenmsgEnterDeleteContact          ; length
    int  80h
    jmp msgDone
    

msgDone:
   
    mov  rsi, msgDisplayDone           ; buffer
    mov  rdx, lenmsgDisplayDone         ; length
    call _print;(rsi = &Buffer, rdx = &len)
    jmp end
    
 exit:
         mov    rax, 1
         mov    rbx, 0
         int    80h
         
         
         
         
         
 _print:;(rsi = &Buffer, rdx = &len)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Change: rax,rbx,rcx          
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

mov rax, 4
mov rbx, 1
mov rcx, rsi      ;rsi = &Buffer
;mov rdx, rdx     ;len_trimmedString
int 80h
ret
;-------------------------------------------------------------------------------------

_input:;(rsi = &Buffer, rdx = &len)
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ;Change: rax,rdi          
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        
    mov rax, 0
    mov rdi, 0
    ;mov rsi, rsi
    ;mov rdx, rdx
    syscall    
ret


_inputWithLength:;(rsi = &Buffer, rdx = &len)://rcx = len of input message, Buffer = input
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ;Change: rax,rdx,rsi,rdi,rbp
        ;Return: rcx = len of input message, Buffer = inputData         
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                
        mov rax, 0
        mov rdi, 0
        ;mov rsi, r10    
        ;mov rdx, r11        
        syscall
        
        push rbp
        mov rbp,rsp                     ; setup a stack frame
        	
        mov rax,rsi                     ; store address of message into eax (caller saved, so we are allowed to modify it)
        jmp getMessageLength_loop2
        
        getMessageLength_loop:
        add rax,	1                      ; next character
        
        getMessageLength_loop2:
        cmp [rax], BYTE 0               ; is dereferenced character at eax the string's NULL truncator?
        jnz getMessageLength_loop
        	
        sub rax,rsi                     ; subtract message from eax to get the difference from the byte that was 0 and the start (string length)
        leave
        
        mov rcx,rax                     ; store counter in rcx

ret
;-------------------------------------------------------------------------------------




_appendInFile:;(rbx = &FileName, rcx = &msg, rdx = Number of Bytes)://rax = [file_descriptor] 
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ;Change: rax,rbx,rcx,rdx,r10,r11,r12
        ;Return: rax = [file_descriptor]          
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        xor r10,r10
        xor r11,r11
        
        mov r10, rcx                ; to store &msg
        mov r11, rdx                ; to store no. of bytes
                
        ;open file
        mov rcx, 2              ; flag for access mode(0 Read Only, 1 Write Only, 2 Read and Write)
        ;mov rbx, FileName      ; filename of the file to open
        mov rax, 5              ; invoke SYS_OPEN (kernel opcode 5)
        int 80h                 ; call the kernel
    
        mov r12, rax            ; to store [file_descriptor]   
        ;;;;;;;;;;;;
        
        ;Append
        mov rdx, 2              ; 0 beginning, 1 current, 2 end
        mov rcx, 0              ; move the cursor 0 bytes
        mov rbx, rax            ; move the opened file descriptor into rbx
        mov rax, 19             ; invoke SYS_LSEEK (kernel opcode 19)
        int 80h                 ; call the kernel
        ;;;;;;;;;;;;
        
        ;Updating by buffer
        mov rdx, r11            ; number of bytes to write - one for each letter of our contents string
        mov rcx, r10            ; move &msg of our contents string into ecx
        mov rbx, rbx            ; move the opened file descriptor into EBX (not required as EBX already has the FD)
        mov rax, 4              ; invoke SYS_WRITE (kernel opcode 4)
        int 80h                 ; call the kernel
        mov rax, r12            ; to restore[file_descriptor] for return
ret      
;-------------------------------------------------------------------------------------


_createFile:;(rbx = &FileName)://rax = [file_descriptor]
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ;Change: rax,rcx
        ;Return: rax = [file_descriptor]          
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
               
        ;mov  rbx, FileName
        mov  rcx, 0o777       ;0o777 read,write and execute, 4 Read, 2 Write, 1 Excute (1+2+4 = 7 ==> 7 owner, 7 group , 7 other)
        mov  rax, 8           ;Sys_Create func number
        int  80h              ;call kernel
ret
;-------------------------------------------------------------------------------------


_clearBuffer:;(rbx = &Buffer)
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ;Change: rbx,rdi       
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;        
        xor rdi,rdi  
        loop_clearBuffer:        
        cmp BYTE[rbx +rdi],0
        je exit_clearBuffer
        mov BYTE[rbx +rdi],0
        inc rdi
        jmp loop_clearBuffer      
        exit_clearBuffer:
ret
;-------------------------------------------------------------------------------------


_clearLastChar:;(rbx = &Buffer,rcx = len)
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ;Change: rbx,rcx       
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        
        mov BYTE[rbx +rcx-1],0
        dec rcx
ret
;-------------------------------------------------------------------------------------



_readFile:;(rbx = &FileName , rdi =&loadedFile )://rax = [file_descriptor] 
        ;open file
        mov rcx, 0              ; flag for access mode(0 Read Only, 1 Write Only, 2 Read and Write)
        ;mov rbx, FileName      ; filename of the file to open
        mov rax, 5              ; invoke SYS_OPEN (kernel opcode 5)
        mov edx, 0o777          ;read, write and execute by all        int 80h                 ; call the kernel
	int 80h
        mov r12, rax            ; to store [file_descriptor]
    
       ;read from file
       mov rax, 3
       mov rbx, r12
       mov rcx, rdi  
       mov rdx, 1024            ;bytes to read
       int 80h
        
       ;close the file
       mov rax, 6
       mov rbx, r12
       int 80h
       
       mov rax, r12
ret
;-------------------------------------------------------------------------------------