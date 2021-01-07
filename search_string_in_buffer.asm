section .data
  
loadedBuffer db "Amr", 10, "Sara", 10,"Gamal", 10,"Ramadan",10,"Amr",10,0
trimmedString times 16 db 0


 
section  .text
  global  main

main:
        ;parameters
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
;;;;;;;;Trim is here
        
        
        ;parameters
        xor rsi,rsi
        xor rdx,rdx
        xor rdi,rdi
        
        ;mov rsi, nam+index         ; rsi = start pos > [&Buffer + index of start]
        add rsi,r10
        add rsi,loadedBuffer
        
        
        ;mov rdx, nam+index          ; rdx = end pos ==> [&Buffer + index of end]  
        add rdx,r11
        add rdx,loadedBuffer     
        
        mov rdi,trimmedString            ; rdi = Distnation buffer 
        
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
        ;mov edx, 16     ;len_trimmedString
        ;int 80h

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;Compare is here 
      
    

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;Clear Buffer
        mov rdi,0  
        clearBuffre_loop:        
        cmp BYTE[trimmedString +rdi],0
        je clearBuffre_exit
        mov BYTE[trimmedString +rdi],0
        add rdi, 1
        jmp clearBuffre_loop      
        clearBuffre_exit:

        
        ;xor rcx,rcx     ; i        
        ;cmp BYTE[trimmedString + rcx], 0
        ;je exit
        ;mov al,0    
        ;mov BYTE[trimmedString + rcx],al
        ;inc rcx 
        ;exit:
        
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;Update before looping again
        mov r10,r11
        add r10,1
        jmp read_CHARbyCHAR_label1       
        read_CHARbyCHAR_done:
        
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



        
