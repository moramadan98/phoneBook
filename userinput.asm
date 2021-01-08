section  .data

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



section .bss
    Input resb 1    
    


section	.text
   global main         
	
main:
    call _getInput
    cmp [Input],1
    je  _AddContact
    
    cmp [Input],2
    je  _Display
    
    cmp [Input],3
    je  _Search
    
    cmp [Input],4
    je  _AddNumber
    
    cmp [Input],5
    je  _DeleteNumber
    
    cmp [Input],6
    je  _DeleteContact
    
    
        
            
getInput:
    mov eax, 0
    mov edi, 0
    mov esi, Input    
    mov edx, 16
    syscall
    
  

                    
print:
    mov rax, 1
    mov rdi, 1
    mov rsi, Input
    mov rdx, 1
    syscall
    ret
                    

_AddContact:
    call print


_Display: 
    call print


_Search: 
    call print


_AddNumber:
    call print

_DeleteNumber:
    call print 

_DeleteContact: 
    call print


_msgDone:
    call print