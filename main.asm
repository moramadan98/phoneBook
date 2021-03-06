
section  .data

filename db 'me.txt', 0h   
newline  db 0ah
 
msgMain db "Choose one of the following Option by enter the option number  ",13,10,"1- Add new contact",13,10,"2- Display all contacts",13,10,"3- Search in contacts",13,10,"4- Add number to existing contact",13,10,"5- Delete one number from contact",13,10,"6- Delete contact ",13,10, 0
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

msgDisplayDeleteNumber db "[!] Choose which number you want to delete by index of number " , 13, 10,">>", 0
lenmsgDisplayDeleteNumber equ $ - msgDisplayDeleteNumber

msgContDeleteNumber db "[!] Choose which number you want to delete by index of number " , 13, 10,">>", 0
lenmsgContDeleteNumber equ $ - msgContDeleteNumber

msgEnterDeleteContact db "[!] Enter contact Name which you want to delete " , 13, 10 ,0
lenmsgEnterDeleteContact equ $ - msgEnterDeleteContact

msgDone db "[^_^] Done ", 13, 10,0
lenmsgDone equ $ - msgDone


msgNotfoundError db "[X] Not Found ", 13, 10,0
lenmsgNotfoundError equ $ - msgNotfoundError

msgEnterError db "[X] Invalid input ", 13, 10,0
lenmsgEnterError equ $ - msgEnterError



choiceAddContact	db	'1'
choiceDisplay	db	'2'
choiceSearch    db	'3'
choiceAddNumber	db	'4'
choiceDeleteNumber db	'5'
choiceDeleteContact db	'6'


section .bss
    name resb 16    
 

section	.text
   global main         
	
main:                 

call  _getName
call  _createFile
call _addContent
call _newLine
;call  _printName
    
_getName:
    mov eax, 0
    mov edi, 0
    mov esi, name    
    mov edx, 16
    syscall
    
    push   rbp
    mov	rbp,rsp			
	
    mov	rax,name		; store address of message into eax (caller saved, so we are allowed to modify it)
    jmp	getMessageLength_loop2

getMessageLength_loop:
    add	rax,	1			; next character

getMessageLength_loop2:
    cmp	[rax],	byte 0		; is dereferenced character at eax the string's NULL truncator?
    jnz	getMessageLength_loop
    	
    sub	rax,	name		; subtract message from eax to get the difference from the byte that was 0 and the start (string length)
    leave
    
    mov rbp,rax    
    
    ret
    
_newLine:
    mov     ecx, 1              ; flag for writeonly access mode (O_WRONLY)
    mov     ebx, filename       ; filename of the file to open
    mov     eax, 5              ; invoke SYS_OPEN (kernel opcode 5)
    int     80h                 ; call the kernel
 
    mov     edx, 2              ; 0 beginning, 1 current, 2 end
    mov     ecx, 0              ; move the cursor 0 bytes
    mov     ebx, eax            ; move the opened file descriptor into EBX
    mov     eax, 19             ; invoke SYS_LSEEK (kernel opcode 19)
    int     80h                 ; call the kernel   
 
    mov     edx, 1              ; number of bytes to write - one for each letter of our contents string 
    mov     ecx, newline        ; move the memory address of our contents string into ecx
    mov     ebx, ebx            ; move the opened file descriptor into EBX
    mov     eax, 4              ; invoke SYS_WRITE (kernel opcode 4)
    int     80h                 
    ret      
    
    
_printName:
    mov rax, 1
    mov rdi, 1
    mov rsi, name
    mov rdx, rbp
    syscall
    ret
    
    
_createFile:
   mov  eax, 8
   mov  ebx, name
   mov  ecx, 0o777        
   int  0x80             
   ret
   
   
          
    
_addContent:
    mov     ecx, 1              ; flag for writeonly access mode (O_WRONLY)
    mov     ebx, filename       ; filename of the file to open
    mov     eax, 5              ; invoke SYS_OPEN (kernel opcode 5)
    int     80h                 ; call the kernel
    
    mov     edx, 2              ; 0 beginning, 1 current, 2 end
    mov     ecx, 0              ; move the cursor 0 bytes
    mov     ebx, eax            ; move the opened file descriptor into EBX
    mov     eax, 19             ; invoke SYS_LSEEK (kernel opcode 19)
    int     80h                 ; call the kernel   
    
                                
    mov     edx, ebp            
    mov     ecx, name           
    mov     ebx, ebx            
    mov     eax, 4              
    int     80h   
    ret
