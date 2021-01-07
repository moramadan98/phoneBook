section .data
  
loadedBuffer db "Amr", 10, "Sara", 10,"Gamal", 10,"Ramadan",10,0
trimmedString times 16 db 0
keyWord db "Amr",0

 
section  .text
  global  main

main:
    mov rbp, rsp; for correct debugging
    
        
        _Search_String_in_Buffer:      
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
        cmp byte [loadedBuffer+r11],0
        je read_CHARbyCHAR_done
        
        cmp byte [loadedBuffer+r11],10
        je read_CHARbyCHAR_update
        
        read_CHARbyCHAR_label1:
         
        ;Print each trimmed name (only TEST)
        ;mov     eax,  4 ;print 
        ;mov     ebx,  1 ; 
        ;lea     ecx,  [loadedBuffer+r11]
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
        add rsi,loadedBuffer
        
        
        ;mov rdx, nam+index             ;rdx = end pos ==> [&Buffer + index of end]  
        add rdx,r11
        add rdx,loadedBuffer     
        
        mov rdi,trimmedString           ;rdi = Distnation buffer 
        
        ;Trim string into buffer (trimmedString) to compare
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
        ;mov ecx, trimmedString
        ;mov edx, 16                ;len_trimmedString
        ;int 80h

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;compare is here (Step 2) 
        
        ;parameters                  ;it's ok to overwrite on last used REG (Anoter Step)
        xor rsi,rsi        
        xor rdi,rdi
        xor rdx, rdx                 ; rdx = 0 ==> (index i)
        
        mov rsi, keyWord             ; rsi = &keyWord
        mov rdi, trimmedString       ; rdi = &trimmedString
        
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
        cmp BYTE[trimmedString +rdi],0
        je clearBuffer_exit
        mov BYTE[trimmedString +rdi],0
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
        ;ret
        
        ;print the info 
        mov eax, 4
        mov ebx, 1
        mov ecx, trimmedString
        mov edx, 16     ;len_trimmedString
        int 80h

        ;exit the program
        mov   eax,  1
        mov   ebx,  0
        int   80h


       
