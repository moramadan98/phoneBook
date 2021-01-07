section .data
s1 db "mohamed", 0h

msg1 db 'enter name to search :  ', 0h
msg2 db 'found', 0h
msg3 db 'not found ', 0h

section  .bss
    input resb 8
    
    section .text
global main
main:

    call _printMsg1
    call getName

            mov rsi, s1     ; esi = &s1
	mov rdi, input     ; edi = &s2
	xor rdx, rdx    ; edx = 0
loop:
	mov al, [rsi + rdx]
	mov bl, [rdi + rdx]
	inc rdx
	cmp al, bl      ; compare two current characters
	jne not_equal   ; not equal
	cmp al, 0       ; at end?
	je equal        ; end of both strings
	jmp loop        ; equal so far
not_equal:
	;mov rdi, 1
            call _printMsg3
	jmp exit
equal:
	;mov rdi, 0
            call _printMsg2
	jmp exit

exit:
	mov rax, 0x2000001  ; sys_exit
	; mov rdi, 0
	syscall



_printMsg1:
   mov eax, 4
   mov ebx, 1
   mov ecx, msg1
   mov edx, 24
   int  0x80
    ret
    
    _printMsg2:
    mov eax, 4
   mov ebx, 1
   mov ecx, msg2
   mov edx, 5
   int  0x80
    ret
    
    _printMsg3:
    mov eax, 4
   mov ebx, 1
   mov ecx, msg3
   mov edx, 9
   int  0x80
    ret
    
    
    
    
    getName:
    mov eax, 0
    mov edi, 0
    mov esi, input    
    mov edx, 8
    syscall  
    
    ret