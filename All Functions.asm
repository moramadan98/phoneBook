section .data
  
loadedBuffer db "Amr", 10, "Sara", 10,"Gamal", 10,"Ramadan",10,0
loadedBuffer_len equ $-loadedBuffer
trimmedString times 16 db 0
trimmedString_len equ $-trimmedString
dashedLine db "-------------------",10,0
dashedLine_len equ $-dashedLine
keyWord db "Aemr",0

 
section  .text
  global  main

main:
    mov rbp, rsp; for correct debugging
    
    
        ;;search
;        mov rbx , loadedBuffer
;        mov r9 , trimmedString
;        call _Search_String_in_Buffer        
        
        ;print before
        mov rsi,loadedBuffer
        mov rdi,loadedBuffer_len
        call _print        
        
        ;remove word
        mov rbx,loadedBuffer        ;&Buffer
        mov rdx,2                   ;number of line
        call _removeLine        
        
        
        ;print dashedLine
        mov rsi,dashedLine
        mov rdi,dashedLine_len
        call _print
        
        
        ;print after
        mov rsi,loadedBuffer
        mov rdi,loadedBuffer_len
        call _print
        
        call _exitProgram
ret
        
           


_Search_String_in_Buffer:; rbx = loadedBuffer,r9 = trimmedString       
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ;Change: r8,r10,r11,rsi,rdi,rbx,rcx,rdx,al,bl
        ;Return: iF Found r8 = 1 , Else r8 = 0       
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;Read Char by Char is here to trim (Step 1.1)
        
        ;parameters
        xor r8 ,r8
        xor r10,r10
        xor r11,r11        
        
        read_CHARbyCHAR_loop1:
        cmp byte [rbx+r11],0
        je read_CHARbyCHAR_done
        
        cmp byte [rbx+r11],10
        je read_CHARbyCHAR_update
        
        read_CHARbyCHAR_label1:
         
        ;Print each trimmed name (only TEST)
        ;mov     eax,  4 ;print 
        ;mov     ebx,  1 ; 
        ;lea     ecx,  [rbx+r11]
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
        add rsi,rbx
        
        
        ;mov rdx, nam+index             ;rdx = end pos ==> [&Buffer + index of end]  
        add rdx,r11
        add rdx,rbx     
        
        mov rdi,r9           ;rdi = Distnation buffer 
        
        ;Trim string into buffer (trimmedString) to compare
        trimString:
        ;len = (end - start) ==> to ignore last char ($ or etc..)
        mov rbp, rdx             
        sub rbp, rsi
        ;inc rbp        
        
        xor rcx,rcx     ; i=0        
       ;for(i=0;i<len;i++)                       
        trimLoop:
        cmp rcx,rbp                  
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
        ;mov ecx, r9
        ;mov edx, 16                ;len_trimmedString
        ;int 80h

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;compare is here (Step 2) 
        
        ;parameters                  ;it's ok to overwrite on last used REG (Anoter Step)
        xor rsi,rsi        
        xor rdi,rdi
        xor rdx, rdx                 ; rdx = 0 ==> (index i)
        
        mov rsi, keyWord             ; rsi = &keyWord
        mov rdi, r9                  ; rdi = &trimmedString
        
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
        cmp BYTE[r9 +rdi],0
        je clearBuffer_exit
        mov BYTE[r9 +rdi],0
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


_clearBuffer:;rbx = &Buffer        
        xor rdi,rdi  
        loop_clearBuffer:        
        cmp BYTE[rbx +rdi],0
        je exit_clearBuffer
        mov BYTE[rbx +rdi],0
        inc rdi
        jmp loop_clearBuffer      
        exit_clearBuffer:
ret

_print:; rsi = &Buffer, rdi = &len
        mov rax, 4
        mov rbx, 1
        mov rcx, rsi
        mov rdx, rdi     ;len_trimmedString
        int 80h
ret

_exitProgram:
        mov   eax,  1
        mov   ebx,  0
        int   80h
ret 

_getLineBorder:;rdx = Line no., rbx = &Buffer
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
        
        getLineBorder_labe:
        inc     r11
        
        jmp getLineBorder_loop
        getLineBorder_updateCounter:
        inc rcx      ; if new line ==> inc counter
        cmp rcx,rdx  ; desired number?
        je gamal    ; if equal
        mov r10,r11
        inc r10
        jmp getLineBorder_label2
        
        gamal:  
        mov r8,1      ; assign detection flag that founded
        ;gamal code     ; r8 start , rdi end
        jmp getLineBorder_done
        
        getLineBorder_done:
ret

_removeLine:;rbx = &Buffer, rdx = Line no.
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ;Change:rax,rbx,rcx,rdx        
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 

        ;parameters: rdx = Line no., rbx = &Buffer 
        call _getLineBorder     ;rdx = Line no., rbx = &Buffer            
        ;return:
        ;r10 = start pos > [&Buffer + index of start]
        ;r11 = end pos ==> [&Buffer + index of end] 
                   
        
        ;removing..        
        mov rdx, r11             
        sub rdx, r10            ;rdx (end - start)
        inc rdx                 ;len = rdx -1
        xor rcx,rcx             ;i=0 
        xor rax,rax             ;clr rax to store null terminator
        mov al,0                ;al = null             
        add rbx,r10             ;rbx = &(Buffer+start pos) 
        removeLine_loop:        ;for(i=0;i<len;i++) 
        cmp rcx,rdx             ;==> to ignore last char ($,\n or etc..)                 
        jge removeLine_exit
        
        mov BYTE[rbx + rcx],al  ;[rbx + r10 + rcx] = Buffer[start pos + i]=''
        inc rcx                 ;i++
        jmp removeLine_loop        
        removeLine_exit:    
ret
