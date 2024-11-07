%include "asm_io.inc"

segment .data
    sum_msg db "The sum of the array is: ", 0  ; Message before the result
    newline db 0xA, 0                          ; Newline character

segment .bss
    array resd 100                              ; Reserve space for 100 integers (4 bytes each)
    sum resd 1                                  ; Reserve space for the sum

segment .text
global asm_main
asm_main:
    pusha

    ; Initialize the array with numbers 1 to 100
    mov ecx, 1                                  ; Start index at 1
    mov edi, array                              ; Point to the start of the array
initialize_array:
    cmp ecx, 101                                ; Check if we've reached 101
    je sum_array                                ; If so, jump to sum_array
    mov [edi], ecx                              ; Store the value of ecx in the array
    add ecx, 1                                  ; Increment ecx
    add edi, 4                                  ; Move to the next array element (4 bytes for an integer)
    jmp initialize_array                        ; Repeat the initialization

sum_array:
    xor eax, eax                                ; Clear eax (sum)
    mov ecx, 100                                ; Set loop counter to 100
    mov edi, array                              ; Point to the start of the array
sum_loop:
    add eax, [edi]                              ; Add array element to eax
    add edi, 4                                  ; Move to the next array element
    loop sum_loop                               ; Decrement ecx and repeat if not zero

    ; Store the result in the sum variable
    mov [sum], eax                              ; Store the sum

    ; Print the sum message
    mov eax, sum_msg
    call print_string                           ; Print the message

    ; Print the result
    mov eax, [sum]                              ; Load the sum into eax
    call print_int                              ; Print the sum

    ; Print a newline after the result
    mov eax, newline
    call print_string                           ; Print a newline

end_program:
    popa
    mov eax, 0                                  ; Return 0 to the OS
    ret
