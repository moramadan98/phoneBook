section  .data

msgMain db 13,10,"Choose one of the following Option by enter the option number  ",13,10,"1- Add new contact",13,10,"2- Display all contacts",13,10,"3- Search in contacts",13,10,"4- Add number to existing contact",13,10,"5- Delete one number from contact",13,10,"6- Delete contact ",13,10,"7- Erase contacts ",13,10,"0- Exit ",13,10,">>", 0

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


msgContDeleteNumber db "[!] Enter which number you want to delete  " , 13, 10,">>", 0
lenmsgContDeleteNumber equ $ - msgContDeleteNumber

msgEnterDeleteContact db "[!] Enter contact Name which you want to delete " , 13, 10,">>" ,0
lenmsgEnterDeleteContact equ $ - msgEnterDeleteContact

msgDisplayDone db 13, 10, "[^_^] Done ", 13, 10,13, 10,13, 10,0
lenmsgDisplayDone equ $ - msgDisplayDone


msgNotfoundError db 13, 10, "[X] Not Found ", 13, 10,0
lenmsgNotfoundError equ $ - msgNotfoundError

msgEnterError db 13, 10, "[X] Invalid input ", 13, 10,0
lenmsgEnterError equ $ - msgEnterError

msgExistError db 13, 10, "[X] Contact name is already exist ", 13, 10,0
lenmsgExistError equ $ - msgExistError

msgEnterNumber db 13, 10, "[!] Enter Number ", 13, 10,">>", 0
lenmsgEnterNumber equ $ - msgEnterNumber

ContactsFile db "contacts.txt" ,0

newline db 0ah

seedFile db "contacts.txt" ,0
length equ $-seedFile

section .bss
   user_input resb 2    ; user input
   user_input_length equ $- user_input
   
   Cname  resb 50
   Cname_len equ $ - Cname
   
   Cnum   resb 50
   Cnum_len equ $ - Cnum
   
   temp  resb 1024
   temp_len equ $ - temp
   
   temp2  resb 1024
   temp2_len equ $ - temp2
   
   loadedFile resb 1024
   loadedFile_len equ $ - loadedFile
   
   

section .text
    global main
 main:  
 	;; sys_open(file, permissions)
	mov	rax, 2		; sys_open
	mov	rdi, seedFile	; file
	mov	rsi, 2		; Read/Write permissions
	syscall

	;; File exists?
	mov	rdx,0          ; not exist if rdx>0
	cmp	rdx,rax
	jle	loop

	;; Create file
	
        mov rbx,seedFile 
        call  _createFile;(rbx = &FileName)://rax = [file_descriptor]

	;; File created sucessfully?
	mov	rdx,0
	cmp	rax,rdx
	jle	loop
 
 ;--------------------------------------------------------------------------------
 loop:  

         ;write
         mov  rax, 4                        ; sys_write
         mov  rbx, 1                        ; stdout
         mov  rcx, msgMain                  ; buffer
         mov  rdx, lenmsgMain               ; length
         int  80h
         
         
       
   ;read
       
         mov  rax, 3                        ; sys_read
         mov  rbx, 0                        ; stdin
         mov  rcx, user_input               ; user input
         mov  rdx, user_input_length        ; max length
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
         
         cmp byte [rcx],55
         je _ResetPhoneBook
         
         cmp byte [rcx],48
         je exit
     
     end:
          jmp loop   
        
 ;-----------------------------------------------------------------------------------------------------------------------------------------------       
_AddContact:
  
    mov rsi ,msgEnterAddContact
    mov rdx ,lenmsgEnterAddContact
    call _print;(rsi = &Buffer, rdx = &len)
    
    mov rsi ,Cname
    mov rdx ,Cname_len  
    call _inputWithLength;(rsi = &Buffer, rdx = &len)://rcx = len of input message, Buffer = input
    
    ; check if null input
    cmp BYTE[Cname], 10     ; cuz we didnt clear last char that = new line = 10
    je msgInvalid
    
    mov rbx ,Cname
    call _clearLastChar;(rbx = &Buffer,rcx = len)
    
    mov r15, rcx            ; to store len of Cname
    
    
    
    ; check if contact exist
    mov rbx ,ContactsFile
    mov rdi , loadedFile
    call  _readFile;(rbx = &FileName , rdi =&loadedFile )://rax = [file_descriptor]
    
    mov r12 ,loadedFile
    mov r13 , Cname
    mov r14 , temp
    call _Search_String_in_Buffer; (r12 = loadedBuffer, r13 = keyWord, r14 = trimmedString)://r8 = 1/0 Found/Not 
    
    cmp r8 , 1
    je msgExist
    
    mov rcx,r15
    ;Else
    mov rdx ,r15
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
    
    ;check if null input
    cmp BYTE[Cnum], 10          ; cuz we didnt clear last char that = new line = 10 
    je msgInvalid
  
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
    


;-----------------------------------------------------------------------------------------------------------------------------------------------

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
 

;-----------------------------------------------------------------------------------------------------------------------------------------------

_Search:
    mov  rax, 4             ; sys_write
    mov  rbx, 1             ; stdout
    mov  rcx, msgEnterSearch           ; buffer
    mov  rdx, lenmsgEnterSearch          ; length
    int  80h
    
     mov rsi ,Cname
    mov rdx ,Cname_len  
    call _inputWithLength;(rsi = &Buffer, rdx = &len)://rcx = len of input message, Buffer = input
    
    ; check if null input
    cmp BYTE[Cname], 10     ; cuz we didnt clear last char that = new line = 10
    je msgInvalid
        
    mov rbx ,Cname
    call _clearLastChar;(rbx = &Buffer,rcx = len)   
    
    
    ;Else    
    mov rbx ,ContactsFile
    mov rdi , loadedFile
    call  _readFile;(rbx = &FileName , rdi =&loadedFile )://rax = [file_descriptor]
    
    mov r12 ,loadedFile
    mov r13 , Cname
    mov r14 , temp
    call _Search_String_in_Buffer; (r12 = loadedBuffer, r13 = keyWord, r14 = trimmedString)://r8 = 1/0 Found/Not 
    
    cmp r8 , 1
    jne _NotFound
    
    
     mov rsi ,Cname
    mov rdx ,Cname_len
    call _print;(rsi = &Buffer, rdx = &len)
    
    mov rsi ,newline
    mov rdx ,1
    call _print;(rsi = &Buffer, rdx = &len)
    
    mov rbx , temp
    call _clearBuffer;(rbx = &Buffer)
    
    mov rbx ,Cname
    mov rdi , temp
    call  _readFile;(rbx = &FileName , rdi =&loadedFile )://rax = [file_descripto
    
     mov rsi ,temp
    mov rdx ,temp_len
    call _print;(rsi = &Buffer, rdx = &len)
    
       mov rbx , Cname
    call _clearBuffer;(rbx = &Buffer)
    
      mov rbx , temp
    call _clearBuffer;(rbx = &Buffer)
    
      mov rbx , loadedFile
    call _clearBuffer;(rbx = &Buffer)
    
    jmp msgDone
    

;-----------------------------------------------------------------------------------------------------------------------------------------------



_AddNumber:
   
    mov rsi ,msgEnterNumber2
    mov rdx ,lenmsgEnterNumber2
    call _print;(rsi = &Buffer, rdx = &len)
    
    mov rsi ,Cname
    mov rdx ,Cname_len  
    call _inputWithLength;(rsi = &Buffer, rdx = &len)://rcx = len of input message, Buffer = input
    
    ; check if null input
    cmp BYTE[Cname], 10     ; cuz we didnt clear last char that = new line = 10
    je msgInvalid
    
    mov rbx ,Cname
    call _clearLastChar;(rbx = &Buffer,rcx = len)
    
    mov r15, rcx            ; to store len of Cname    
    
    
    ; check if contact exist
    mov rbx ,ContactsFile
    mov rdi , loadedFile
    call  _readFile;(rbx = &FileName , rdi =&loadedFile )://rax = [file_descriptor]
    
    mov r12 ,loadedFile
    mov r13 , Cname
    mov r14 , temp
    call _Search_String_in_Buffer; (r12 = loadedBuffer, r13 = keyWord, r14 = trimmedString)://r8 = 1/0 Found/Not 
    
    cmp r8 , 1
    jne _NotFound
    
    mov rcx,r15             ; to restore len of Cname
    ;Else
        
    mov rsi ,msgEnterNumber
    mov rdx ,lenmsgEnterNumber
    call _print;(rsi = &Buffer, rdx = &len)
    
    mov rsi ,Cnum
    mov rdx ,Cnum_len  
    call _inputWithLength;(rsi = &Buffer, rdx = &len)://rcx = len of input message, Buffer = input
    
    ;check if null input
    cmp BYTE[Cnum], 10          ; cuz we didnt clear last char that = new line = 10 
    je msgInvalid
    
    
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
    
     mov rbx , Cname
    call _clearBuffer;(rbx = &Buffer)
    
     mov rbx , Cnum
    call _clearBuffer;(rbx = &Buffer)
    
    jmp msgDone
    
    ;-----------------------------------------------------------------------------------------------------------------------------------------------
    
_DeleteNumber: 
   
   mov rsi ,msgEnterDeleteNumber
    mov rdx ,lenmsgEnterDeleteNumber
    call _print;(rsi = &Buffer, rdx = &len)
    
     mov rsi ,Cname
    mov rdx ,Cname_len  
    call _inputWithLength;(rsi = &Buffer, rdx = &len)://rcx = len of input message, Buffer = input
    
      ; check if null input
    cmp BYTE[Cname], 10     ; cuz we didnt clear last char that = new line = 10
    je msgInvalid  
    
    mov rbx ,Cname
    call _clearLastChar;(rbx = &Buffer,rcx = len)
    
    mov r15, rcx            ; to store len of Cname      
    
    
    ; check if contact exist
    mov rbx ,ContactsFile
    mov rdi , loadedFile
    call  _readFile;(rbx = &FileName , rdi =&loadedFile )://rax = [file_descriptor]
    
    mov r12 ,loadedFile
    mov r13 , Cname
    mov r14 , temp
    call _Search_String_in_Buffer; (r12 = loadedBuffer, r13 = keyWord, r14 = trimmedString)://r8 = 1/0 Found/Not 
    
    cmp r8 , 1
    jne _NotFound
    
     mov rcx,r15             ; to restore len of Cname
     mov rbx , temp
     call _clearBuffer;(rbx = &Buffer)     
     
    ;Else    
    mov rbx ,Cname
    mov rdi , temp
    call  _readFile;(rbx = &FileName , rdi =&loadedFile )://rax = [file_descripto
    
     mov rsi ,temp
    mov rdx ,temp_len
    call _print;(rsi = &Buffer, rdx = &len)
    
    
    mov rsi ,msgContDeleteNumber
    mov rdx ,lenmsgContDeleteNumber
    call _print;(rsi = &Buffer, rdx = &len)
    
     mov rsi ,Cnum
    mov rdx ,Cnum_len  
    call _inputWithLength;(rsi = &Buffer, rdx = &len)://rcx = len of input message, Buffer = input
      
    mov rbx ,Cnum
    call _clearLastChar;(rbx = &Buffer,rcx = len)
        
    ;check if null input
    cmp BYTE[Cnum], 0          
    je msgInvalid
    
    mov rbx , temp
    call _getBufferSize;(rbx = &Buffer):// rdi = length
    
    mov r15 , rdi
    
    mov r12 ,temp
    mov r13 , Cnum
    mov r14 , temp2
    call _Search_String_in_Buffer; (r12 = loadedBuffer, r13 = keyWord, r14 = trimmedString)://r8 = 1/0 Found/Not 
    
    cmp r8 , 1
    jne _NotFound
    
   
    
    mov rbx ,temp
    mov rsi , r10
    mov rdi , r11
    call _removeStringinBuffer;(rbx = &Buffer, rsi = start pos., rdi = end pos.)
    
   
    
    mov rbx,Cname
    mov rcx, temp
    mov rdx ,r15
    call _overwriteFile;(rbx = &FileName, rcx = &msg, rdx = Number of Bytes)://rax = [file_descriptor]
    
    
     mov rbx , Cname
    call _clearBuffer;(rbx = &Buffer)
    
     mov rbx , Cnum
    call _clearBuffer;(rbx = &Buffer)
    
     mov rbx , temp
    call _clearBuffer;(rbx = &Buffer)
    
     mov rbx , temp2
    call _clearBuffer;(rbx = &Buffer)

    jmp msgDone
 
;-----------------------------------------------------------------------------------------------------------------------------------------------   
_DeleteContact:
    mov  rax, 4             ; sys_write
    mov  rbx, 1             ; stdout
    mov  rcx, msgEnterDeleteContact           ; buffer
    mov  rdx, lenmsgEnterDeleteContact          ; length
    int  80h
    
     mov rsi ,Cname
    mov rdx ,Cname_len  
    call _inputWithLength;(rsi = &Buffer, rdx = &len)://rcx = len of input message, Buffer = input
  
    ; check if null input
    cmp BYTE[Cname], 10     ; cuz we didnt clear last char that = new line = 10
    je msgInvalid  
    
    mov rbx ,Cname
    call _clearLastChar;(rbx = &Buffer,rcx = len)
    
    ; check if contact exist
    mov rbx ,ContactsFile
    mov rdi , loadedFile
    call  _readFile;(rbx = &FileName , rdi =&loadedFile )://rax = [file_descriptor]
    
    mov r12 ,loadedFile
    mov r13 , Cname
    mov r14 , temp
    call _Search_String_in_Buffer; (r12 = loadedBuffer, r13 = keyWord, r14 = trimmedString)://r8 = 1/0 Found/Not 
    
    cmp r8 , 1
    jne _NotFound
    
     mov rcx,r15             ; to restore len of Cname
     mov rbx , temp
     call _clearBuffer;(rbx = &Buffer)     
     
    ;Else   

     mov rbx ,ContactsFile
    mov rdi , loadedFile
    call  _readFile;(rbx = &FileName , rdi =&loadedFile )://rax = [file_descriptor]
    
    mov rbx , loadedFile
    call _getBufferSize;(rbx = &Buffer):// rdi = length
    
    mov r15 , rdi
    
    mov r12 ,loadedFile
    mov r13 , Cname
    mov r14 , temp
    call _Search_String_in_Buffer; (r12 = loadedBuffer, r13 = keyWord, r14 = trimmedString)://r8 = 1/0 Found/Not 
    
    cmp r8 , 1
    jne _NotFound
    
   
    
    mov rbx ,loadedFile
    mov rsi , r10
    mov rdi , r11
    call _removeStringinBuffer;(rbx = &Buffer, rsi = start pos., rdi = end pos.)
    
   
    
    mov rbx,ContactsFile
    mov rcx, loadedFile
    mov rdx ,r15
    call _overwriteFile;(rbx = &FileName, rcx = &msg, rdx = Number of Bytes)://rax = [file_descriptor]
    
    mov rbx ,Cname
    call _deleteFile;(rbx = &FileName)
    
    
    mov rbx , Cname
    call _clearBuffer;(rbx = &Buffer)
    
    mov rbx , loadedFile
    call _clearBuffer;(rbx = &Buffer)
    jmp msgDone
 
;-----------------------------------------------------------------------------------------------------------------------------------------------   
_ResetPhoneBook:
    
    mov rbx ,ContactsFile
    mov rdi , loadedFile
    call  _readFile;(rbx = &FileName , rdi =&loadedFile )://rax = [file_descriptor]
    
    mov r12 ,loadedFile    
    mov r14 , temp 
    call _resetPhoneBook; (r12 = loadedBuffer, r14 = trimmedString)
    
    mov rbx , loadedFile
    call _clearBuffer;(rbx = &Buffer)
    mov rbx , temp
    call _clearBuffer;(rbx = &Buffer)
    
    jmp msgDone_main
        
 
;-----------------------------------------------------------------------------------------------------------------------------------------------   
  
  _NotFound:  
    mov  rax, 4             ; sys_write
    mov  rbx, 1             ; stdout
    mov  rcx, msgNotfoundError           ; buffer
    mov  rdx, lenmsgNotfoundError        ; length
    int  80h
    
    jmp msgDone
;-----------------------------------------------------------------------------------------------------------------------------------------------
msgDone:
   
    mov  rsi, msgDisplayDone           ; buffer
    mov  rdx, lenmsgDisplayDone         ; length
    call _print;(rsi = &Buffer, rdx = &len)
    jmp end
    
msgDone_main:
    mov  rsi, msgDisplayDone           ; buffer
    mov  rdx, lenmsgDisplayDone         ; length
    call _print;(rsi = &Buffer, rdx = &len)
    jmp main        ; to create new contacts file 
    
msgInvalid:
    mov  rsi, msgEnterError           ; buffer
    mov  rdx, lenmsgEnterError        ; length
    call _print;(rsi = &Buffer, rdx = &len)
    jmp end
    
msgExist:
    mov  rsi, msgExistError           ; buffer
    mov  rdx, lenmsgExistError        ; length
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
        
        xor rcx,rcx
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



_Search_String_in_Buffer:; (r12 = loadedBuffer, r13 = keyWord, r14 = trimmedString)://r8 = 1/0 Found/Not       
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ;Change: r8,r10,r11,r12,r13,rsi,rdi,rbp,rbx,rcx,rdx,al,bl
        ;Return: iF Found r8 = 1 , Else r8 = 0       
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ;mov r12, rsi         ;temp reg to store &trimmedString (will change before its stage) 
        ;mov r13, rdi        ;temp reg to store &keyWord  (will change before its stage) 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;Read Char by Char is here to trim (Step 1.1)      
 
        
        ;parameters
        xor r8 ,r8
        xor r10,r10
        xor r11,r11        
        
        read_CHARbyCHAR_loop1:
        cmp byte [r12+r11],0
        je read_CHARbyCHAR_done
        
        cmp byte [r12+r11],10
        je read_CHARbyCHAR_update
        
        read_CHARbyCHAR_label1:
         
        ;Print each trimmed name (only TEST)
        ;mov     eax,  4 ;print 
        ;mov     ebx,  1 ; 
        ;lea     ecx,  [r12+r11]
        ;mov     edx,  1
        ;int     80h
        
        ;increment the loop counter
        inc r11   
        jmp read_CHARbyCHAR_loop1        
        read_CHARbyCHAR_update:  
        
        ;r10 start pos
        ;r11 end pos    
     

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;Trim is here (Step 1.2)       
        
        ;parameters      
        xor rsi,rsi
        xor rdx,rdx
        xor rdi,rdi
        
        ;mov rsi, nam+index             ;rsi = start pos > [&Buffer + index of start]
        add rsi,r10
        add rsi,r12
        
        
        ;mov rdx, nam+index             ;rdx = end pos ==> [&Buffer + index of end]  
        add rdx,r11
        add rdx,r12     
        
        mov rdi,r14           ;rdi = Distnation buffer 
        
        ;Trim string into buffer (r14) to compare
        trimString:
        ;len = (end - start) ==> to ignore last char ($ or etc..)
        mov rbx, rdx             
        sub rbx, rsi
        ;inc rbx        
        
        xor rcx,rcx     ; i=0        
       ;for(i=0;i<len;i++)                       
        trimLoop:
        cmp rcx,rbx                  
        jge exit_trimString
        
        xor rax,rax
        ;des[i]=sor[i]
        mov al, BYTE[rsi + rcx]   
        mov BYTE[rcx + rdi],al
        inc rcx
        jmp trimLoop        
        exit_trimString:     

        ;Print each trimmed name (only TEST) 
        ;mov eax, 4
        ;mov ebx, 1
        ;mov ecx, r14
        ;mov edx, 16                ;len_trimmedString
        ;int 80h

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;compare is here (Step 2) 
        
        ;parameters                  ;it's ok to overwrite on last used REG (Anoter Step)
        xor rsi,rsi        
        xor rdi,rdi
        xor rdx, rdx                 ; rdx = 0 ==> (index i)
        
        mov rsi, r13                 ; rsi = &keyWord
        mov rdi, r14                 ; rdi = &trimmedString
        
        cmpString_loop:
        mov al, [rsi + rdx]
        mov bl, [rdi + rdx]
        inc rdx
        cmp al, bl                  ; compare two current characters
        jne cmpString_notEqual      ; not equal
        cmp al, 0                   ; at end?
        je cmpString_equal          ; end of both strings
        jmp cmpString_loop          ; equal so far
        
        cmpString_notEqual:          
        mov r8, 0                   ; to indicate if not found till end of outer loop
        jmp cmpString_exit          ; to clear Buffer before the next iteration of searching
        
        cmpString_equal:
        mov r8, 1                   ; to indicate if found till end of outer loop        
        jmp _Search_String_in_Buffer_exit    ; Found! ==> So, exit from _Search_String_in_Buffer  
        cmpString_exit:    
        
        ; r8 = 1 Found
        ; r8 = 0 Not Found

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;Clear Buffer (Step 3 ==> if not found  ==> r8 = 0)
        ;call _clearBuffer:        
        xor rdi,rdi  
        clearBuffer_loop:        
        cmp BYTE[r14 +rdi],0
        je clearBuffer_exit
        mov BYTE[r14 +rdi],0
        inc rdi
        jmp clearBuffer_loop      
        clearBuffer_exit:        
        
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;Update before looping again
        mov r10,r11
        inc r10
        jmp read_CHARbyCHAR_label1       
        read_CHARbyCHAR_done:        
        _Search_String_in_Buffer_exit:
ret
;-------------------------------------------------------------------------------------
_resetPhoneBook:; (r12 = loadedBuffer, r14 = trimmedString)       
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ;Change: r8,r10,r11,r12,r13,rsi,rdi,rbp,rbx,rcx,rdx,al,bl
        ;Return: iF Found r8 = 1 , Else r8 = 0       
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ;mov r12, rsi         ;temp reg to store &trimmedString (will change before its stage) 
        ;mov r13, rdi        ;temp reg to store &keyWord  (will change before its stage) 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;Read Char by Char is here to trim (Step 1.1)      
 
        
        ;parameters
        xor r8 ,r8
        xor r10,r10
        xor r11,r11        
        
        read_CHARbyCHAR_loop1_reset:
        cmp byte [r12+r11],0
        je read_CHARbyCHAR_done_reset
        
        cmp byte [r12+r11],10
        je read_CHARbyCHAR_update_reset
        
        read_CHARbyCHAR_label1_reset:
         
        ;Print each trimmed name (only TEST)
        ;mov     eax,  4 ;print 
        ;mov     ebx,  1 ; 
        ;lea     ecx,  [r12+r11]
        ;mov     edx,  1
        ;int     80h
        
        ;increment the loop counter
        inc r11   
        jmp read_CHARbyCHAR_loop1_reset        
        read_CHARbyCHAR_update_reset:  
        
        ;r10 start pos
        ;r11 end pos    
     

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;Trim is here (Step 1.2)       
        
        ;parameters      
        xor rsi,rsi
        xor rdx,rdx
        xor rdi,rdi
        
        ;mov rsi, nam+index             ;rsi = start pos > [&Buffer + index of start]
        add rsi,r10
        add rsi,r12
        
        
        ;mov rdx, nam+index             ;rdx = end pos ==> [&Buffer + index of end]  
        add rdx,r11
        add rdx,r12     
        
        mov rdi,r14           ;rdi = Distnation buffer 
        
        ;Trim string into buffer (r14) to compare
        trimString_reset:
        ;len = (end - start) ==> to ignore last char ($ or etc..)
        mov rbx, rdx             
        sub rbx, rsi
        ;inc rbx        
        
        xor rcx,rcx     ; i=0        
       ;for(i=0;i<len;i++)                       
        trimLoop_reset:
        cmp rcx,rbx                  
        jge exit_trimString_reset
        
        xor rax,rax
        ;des[i]=sor[i]
        mov al, BYTE[rsi + rcx]   
        mov BYTE[rcx + rdi],al
        inc rcx
        jmp trimLoop_reset        
        exit_trimString_reset:     

        ;Print each trimmed name (only TEST) 
        ;mov eax, 4
        ;mov ebx, 1
        ;mov ecx, r14
        ;mov edx, 16                ;len_trimmedString
        ;int 80h

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;; delete is here 
        
        ;parameters                  ;it's ok to overwrite on last used REG (Anoter Step)
        xor rsi,rsi        
        xor rdi,rdi
        xor rdx, rdx                 ; rdx = 0 ==> (index i)
        
        mov rdi,rbx                  ; store rbx for any next need
        mov rbx, r14                 ; r14 = &trimmedString        
        call _deleteFile;(rbx = &FileName)
        mov rbx, rdi                 ; restore rbx for any next need

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;Clear Buffer (Step 3 ==> if not found  ==> r8 = 0)
        ;call _clearBuffer:        
        xor rdi,rdi  
        clearBuffer_loop_reset:        
        cmp BYTE[r14 +rdi],0
        je clearBuffer_exit_reset
        mov BYTE[r14 +rdi],0
        inc rdi
        jmp clearBuffer_loop_reset      
        clearBuffer_exit_reset:        
        
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;Update before looping again
        mov r10,r11
        inc r10
        jmp read_CHARbyCHAR_label1_reset       
        read_CHARbyCHAR_done_reset:        
        _Search_String_in_Buffer_exit_reset:
        mov rbx, seedFile
        call _deleteFile;(rbx = &FileName)
        
ret
;-------------------------------------------------------------------------------------
_removeStringinBuffer:;(rbx = &Buffer, rsi = start pos., rdi = end pos.)
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ;Change: rax,rbx,rcx,rdx          
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
        
        mov rdx, rdi             
        sub rdx, rsi            ;rdx (end - start)
        inc rdx                 ;len = rdx -1
        xor rcx,rcx             ;i=0 
        xor rax,rax             ;clr rax to store null terminator
        mov al,20h              ;al = null             
        add rbx,rsi             ;rbx = &(Buffer+start pos) 
        removeStringinBuffer_loop:        ;for(i=0;i<len;i++) 
        cmp rcx,rdx             ;==> to ignore last char ($,\n or etc..)                 
        jge removeStringinBuffer_exit
        
        mov BYTE[rbx + rcx],al  ;[rbx + rsi + rcx] = Buffer[start pos + i]=''
        inc rcx                 ;i++
        jmp removeStringinBuffer_loop        
        removeStringinBuffer_exit:
        mov BYTE[rbx + rcx-1],10
ret
;-------------------------------------------------------------------------------------------------------------------------------



_deleteFile:;(rbx = &FileName)
    ;mov     rbx, filename       
    mov     rax, 10             
    int     80h
ret     
;-------------------------------------------------------------------------------------


_overwriteFile:;(rbx = &FileName, rcx = &msg, rdx = Number of Bytes)://rax = [file_descriptor] 
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ;Change: rax, rcx
        ;Return: rax = [file_descriptor]          
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        
        xor r11, r11
        mov r11,rcx         ;stor &msg befor changing in _createFile func
        
        call _createFile;(rbx = FileName)://rax = [file_descriptor]
        
        xor r10, r10         
        mov r10, rax        ;store [file_descriptor] befor changing in _writeFile func 
        
        mov rcx,r11         ;restore &msg in rcx
        mov rbx, rax        
        call _writeFile     ;(rcx = msg, rbx = [file_descriptor], rdx = Number of Bytes) 
        mov rax, r10        ;restore [file_descriptor] in rax       
        
ret
;------------------------------------------------------------------------------------------------------------------------


_writeFile:;(rcx = &msg, rbx = [file_descriptor], rdx = Number of Bytes)
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ;Change: rax          
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        
        ;mov rdx,len                    ;number of bytes
        ;mov rcx, msg                   ;message to write
        ;mov rbx, [file_descriptor]     ;file descriptor 
        mov rax ,4                      ;invoke SYS_WRITE (kernel opcode 4)
        int 80h                         ;call kernel   
ret
;-------------------------------------------------------------------------------------

_getBufferSize:;(rbx = &Buffer):// rdi = length
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ;Change: rbx,rdi
        ;Return: rdi = Length       
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;        
        xor rdi,rdi  
        loop_getBufferSize:        
        cmp BYTE[rbx +rdi],0
        je exit_getBufferSize
        ;mov BYTE[rbx +rdi],0
        inc rdi
        jmp loop_getBufferSize      
        exit_getBufferSize:
ret
;-------------------------------------------------------------------------------------
