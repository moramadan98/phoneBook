section .data
  
loadedBuffer db "Amr", 10, "Sara", 10,"Gamal", 10,"Ramadan",10,0
loadedBuffer_len equ $-loadedBuffer
trimmedString times 16 db 0
trimmedString_len equ $-trimmedString
dashedLine db "-------------------",10,0
dashedLine_len equ $-dashedLine
keyWord db "Sara",0

section .bss
file_descriptor resb 10

 
section  .text
  global  main

main:        
        call _exitProgram
ret
        
           
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
_openFileRW:;(rbx = &FileName)://Return: rax = [file_descriptor]
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ;Change: rax, rcx, rdx 
        ;Return: rax = [file_descriptor]         
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        
        ;mov rbx, FileName
        mov rax, 5              ; invoke SYS_OPEN (kernel opcode 5)        
        mov rcx, 2              ;0 Read Only, 1 Write Only, 2 Read and Write
        mov rdx, 0o777          ;read, write and execute by all(7 user,7 owner, 7 group)
        int 0x80       	       ;call kernel        
;-------------------------------------------------------------------------------------
_closeFile:;(rbx = [file_descriptor])
        mov eax, 6            ;invoke SYS_CLOSE (kernel opcode 6)
ret
;-------------------------------------------------------------------------------------
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
;-------------------------------------------------------------------------------------
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
_exitProgram:;()
        mov   eax,  1
        mov   ebx,  0
        int   80h
ret 
;-------------------------------------------------------------------------------------
_getLineBorder:;(rdx = Line no., rbx = &Buffer)://r8 = 1/0 Found/Not, r10 = startPos, r11 = endPos
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ;Change: r8,r10,r11,rcx,rdx,rbx
        ;Return: iF Found r8 = 1 , Else r8 = 0, r10 ==> start, r11 ==> end        
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
        
        ;parameters
        xor r8, r8               ;found = 1 , not found 0
        xor r10,r10              ;start pos
        xor r11, r11             ;end pos        
        xor rcx,rcx              ;counter of new line         
        
        
        getLineBorder_loop:
        cmp BYTE [rbx+r11],10
        je getLineBorder_updateCounter
        
        getLineBorder_label2: 
        cmp BYTE [rbx+r11], 0
        je getLineBorder_done
        
        getLineBorder_label1:
        inc     r11        
        jmp getLineBorder_loop
        
        getLineBorder_updateCounter:
        inc rcx         ; if new line ==> inc counter
        cmp rcx,rdx     ; desired number?
        je getLineBorder_equal        ; if equal
        
        mov r10,r11
        inc r10
        jmp getLineBorder_label2
        
        getLineBorder_equal:  
        mov r8,1        ; assign detection flag that founded
        ;Gamal code     
        jmp getLineBorder_done
        
        getLineBorder_done:
ret
;-------------------------------------------------------------------------------------
_removeLineNo:;(rbx = &Buffer, rdx = Line no.)
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ;Change:rax,rbx,rcx,rdx,r8,r10,r11        
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 

        call _getLineBorder;(rdx = Line no., rbx = &Buffer)://r8 = 1/0 Found/Not, r10 = startPos, r11 = endPos
        ;return:
        ;r10 = start pos > [&Buffer + index of start]
        ;r11 = end pos ==> [&Buffer + index of end] 
                   
        
        ;removing..        
        mov rdx, r11            ;             
        sub rdx, r10            ;rdx = (end - start)    to get effLen = (word + $)
        inc rdx                 ;effLen = rdx +1
        xor rcx,rcx             ;i=0 
        xor rax,rax             ;clr rax to store null terminator
        mov al,0                ;al = null             
        add rbx,r10             ;rbx = &(Buffer+start pos) 
        removeLineNo_loop:      ;for(i=0;i<len;i++) 
        cmp rcx,rdx             ;==> to ignore last char ($,\n or etc..)                 
        jge removeLineNo_exit
        
        mov BYTE[rbx + rcx],al  ;[rbx + r10 + rcx] = Buffer[start pos + i]=''
        inc rcx                 ;i++
        jmp removeLineNo_loop        
        removeLineNo_exit:    
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
        mov al,0                ;al = null             
        add rbx,rsi             ;rbx = &(Buffer+start pos) 
        removeStringinBuffer_loop:        ;for(i=0;i<len;i++) 
        cmp rcx,rdx             ;==> to ignore last char ($,\n or etc..)                 
        jge removeStringinBuffer_exit
        
        mov BYTE[rbx + rcx],al  ;[rbx + rsi + rcx] = Buffer[start pos + i]=''
        inc rcx                 ;i++
        jmp removeStringinBuffer_loop        
        removeStringinBuffer_exit:
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
