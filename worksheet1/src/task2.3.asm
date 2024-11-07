%include "asm_io.inc"

segment .data
    sum_msg db "The sum of the range is: ", 0          ; Message before the result
    range_msg db "Enter the range (1 to 100): ", 0     ; Prompt message for range
    err_msg db "Error: Range must be between 1 and 100!", 0 ; Error message
    newline db 0xA, 0                                  ; Newline character

segment .bss
    array resd 100                                     ; Reserve space for 100 integers
    sum resd 1                                         ; Reserve space for the sum
    lower_bound resd 1                                 ; Reserve space for the lower range
    upper_bound resd 1                                 ; Reserve space for the upper range

segment .text
global asm_main
asm_main:
    pusha

    ; Initialize the array with numbers 1 to 100
    mov ecx, 1                                         ; Start index at 1
    mov edi, array                                     ; Point to the start of the array
initialize_array:
    cmp ecx, 101                                       ; Check if we've reached 101
    je prompt_range                                    ; If so, jump to prompt_range
    mov [edi], ecx                                     ; Store the value of ecx in the array
    add ecx, 1                                         ; Increment ecx
    add edi, 4                                         ; Move to the next array element (4 bytes for an integer)
    jmp initialize_array                               ; Repeat the initialization

prompt_range:
    ; Prompt the user for a range
    mov eax, range_msg                                 ; Load the prompt message
    call print_string                                  ; Print the message

    ; Read the lower bound
    call read_int                                      ; Read integer input
    mov [lower_bound], eax                             ; Store the lower bound

    ; Read the upper bound
    call read_int                                      ; Read integer input
    mov [upper_bound], eax                             ; Store the upper bound

    ; Validate the range
    mov eax, [lower_bound]                             ; Load lower bound into eax
    cmp eax, 1                                         ; Check if it's less than 1
    jl invalid_range                                   ; Jump to error handling if lower bound < 1
    mov eax, [upper_bound]                             ; Load upper bound into eax
    cmp eax, 100                                       ; Check if it's greater than 100
    jg invalid_range                                   ; Jump to error handling if upper bound > 100

    mov eax, [lower_bound]                             ; Load lower bound into eax again
    mov ebx, [upper_bound]                             ; Load upper bound into ebx
    cmp eax, ebx                                       ; Compare lower bound with upper bound
    jg invalid_range                                   ; Jump to error if lower bound > upper bound

    ; Calculate the sum of the specified range
    mov ecx, [lower_bound]                             ; Set ecx to lower bound
    mov edx, [upper_bound]                             ; Set edx to upper bound
    xor eax, eax                                       ; Clear eax (sum)
sum_range:
    cmp ecx, edx                                       ; Compare current index with upper bound
    jg display_sum                                     ; If current index is greater than upper bound, jump to display_sum
    mov esi, [array + (ecx - 1) * 4]                   ; Load the value from the array (correct index calculation)
    add eax, esi                                       ; Add the value to the sum
    inc ecx                                            ; Increment index
    jmp sum_range                                      ; Repeat the summation

display_sum:
    ; Print the sum message
    mov [sum], eax                                     ; Store the sum
    mov eax, sum_msg
    call print_string                                  ; Print the message

    ; Print the result
    mov eax, [sum]                                     ; Load the sum into eax
    call print_int                                     ; Print the sum

    ; Print a newline after the result
    mov eax, newline
    call print_string                                  ; Print a newline

    jmp end_program                                    ; Jump to end

invalid_range:
    ; Print the error message
    mov eax, err_msg                                   ; Load error message
    call print_string                                  ; Print the error message

    ; Print a newline
    mov eax, newline
    call print_string                                  ; Print a newline

    jmp prompt_range                                   ; Ask for the range again

end_program:
    popa
    mov eax, 0                                         ; Return 0 to the OS
    ret
