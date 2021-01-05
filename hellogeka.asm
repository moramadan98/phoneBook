
section  .data

filename db 'me.txt', 0h   
newline  db 0ah  




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
    mov	rbp,rsp			; setup a stack frame
	
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
    int     80h                 ; call the kernel  
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
    
                                ;bp actual length
    mov     edx, ebp            ; number of bytes to write - one for each letter of our contents string
    mov     ecx, name           ; move the memory address of our contents string into ecx
    mov     ebx, ebx            ; move the opened file descriptor into EBX (not required as EBX already has the FD)
    mov     eax, 4              ; invoke SYS_WRITE (kernel opcode 4)
    int     80h   
    ret