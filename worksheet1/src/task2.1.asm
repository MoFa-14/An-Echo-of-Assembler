%include "asm_io.inc"

segment .data
    namemsg db "What is your name? ", 0
    nummsg db "Please enter a number between 50 and 100 for messages you want to display: ", 0
    welcomemsg db "Welcome ", 0
    errormsg db "Error: Number must be between 50 and 100!", 0
    newline db 0xA, 0               ; newline character

segment .bss
    name resb 100       ; buffer to store the user's name
    num resd 1          ; to store the input number

segment .text
global asm_main
asm_main:
    pusha

    ; Display prompt for the user's name
    mov eax, namemsg
    call print_string

    ; Read the user's name
    mov eax, name           ; load address of `name` buffer
    call read_name           ; read name character by character

input_number:
    ; Display prompt for the number of times to print the message
    mov eax, nummsg
    call print_string

    ; Read the number
    call read_int            ; read integer input
    mov [num], eax           ; store the input number in `num`

    ; Validate if the number is between 50 and 100
    mov eax, [num]
    cmp eax, 50
    jl too_small             ; if number < 50, jump to `too_small`
    cmp eax, 100
    jg too_large             ; if number > 100, jump to `too_large`

    ; Print the welcome message [num] times
    mov ecx, [num]           ; set ECX to the number of iterations
print_loop:
    ; Print "Welcome, "
    mov eax, welcomemsg
    call print_string

    ; Print the user's name
    mov eax, name
    call print_string

    ; Print a newline
    mov eax, newline
    call print_string

    loop print_loop          ; decrement ECX and repeat loop if not zero
    jmp end_program          ; jump to `end_program` once done

too_small:
    mov eax, errormsg       ; load error message
    call print_string        ; print the error message
    mov eax, newline         ; prepare newline character
    call print_string        ; print newline
    jmp input_number         ; jump back to input number

too_large:
    mov eax, errormsg       ; load error message
    call print_string        ; print the error message
    mov eax, newline         ; prepare newline character
    call print_string        ; print newline
    jmp input_number         ; jump back to input number

end_program:
    popa
    mov eax, 0               ; return 0 to the OS
    ret

; Read name character-by-character function
read_name:
    pusha                    ; save registers
    mov ecx, 0               ; set index to 0
read_loop:
    call read_char           ; read a single character
    cmp al, 0xA              ; check if it's a newline character (end of input)
    je done_reading          ; if newline, finish reading
    mov [name + ecx], al     ; store the character in the buffer
    inc ecx                  ; increment index
    jmp read_loop            ; loop to read next character
done_reading:
    mov byte [name + ecx], 0 ; terminate string with a null character
    popa                     ; restore registers
    ret
