INCLUDE Irvine32.inc

.data
    title_msg byte "      Matrix Operations Tool by Muzamil & Harsh",0
    main_menu_msg byte "1.Configure Matrix A",10
                  byte "2.Configure Matrix B",10
                  byte "3.Matrix Addition",10
                  byte "4.Matrix Subtraction",10
                  byte "5.Element Square",10
                  byte "6.Element Cube",10
                  byte "7.Add Constant",10
                  byte "8.Subtract Constant",10
                  byte "9.Multiply by Constant",10
                  byte "10.Divide by Constant",10
                  byte "11.Transpose (3X3 only)",10
                  byte "12.2x2 Determinant",10
                  byte "13.3x3 Determinant",10
                  byte "14.Display Matrix A",10
                  byte "15.Display Matrix B",10
                  byte "16.Exit",10,10,"SELECT OPTION: ",0
    
    prompt_rows byte "Enter Row Count: ",0
    prompt_cols byte "Enter Column Count: ",0
    mat_a_label byte "Matrix_A[",0
    index_sep byte "][",0
    mat_b_label byte "Matrix_B[",0
    value_prompt byte "]:",0
    result_label byte "Result[",0
    
    ; Matrix storage
    first_matrix sbyte 36 dup(?)
    second_matrix sbyte 36 dup(?)
    result_matrix sbyte 36 dup(?)
    
    ; Operation prompts
    const_add_prompt byte "Enter Constant to Add: ",0
    const_sub_prompt byte "Enter Constant to Subtract: ",0
    const_mul_prompt byte "Enter Multiplier: ",0
    const_div_prompt byte "Enter Divisor: ",0
    
    ; Error messages
    size_mismatch byte "Matrix dimensions incompatible for this operation!",0
    zero_size_err byte "Zero dimensions invalid! Please enter valid size",0
    max_size_err byte "Maximum size is 6! Please enter valid size!",0
    invalid_option byte "Invalid selection!",0
    
    ; Matrix dimensions
    rows_a byte ?
    rows_b byte ?
    rows_res byte ?
    cols_a byte ?
    cols_b byte ?
    cols_res byte ?
    
    ; Variables for operations
    temp1 WORD ?
    temp2 WORD ?
    
    ; Selection messages
    square_sel byte "1.Square Matrix A",10,"2.Square Matrix B",10,"Select: ",0
    cube_sel byte "1.Cube Matrix A",10,"2.Cube Matrix B",10,"Select: ",0
    div_sel byte "1.Divide Matrix A?",10,"2.Divide Matrix B?",10,"Select: ",0
    add_sel byte "1.Add to Matrix A?",10,"2.Add to Matrix B?",10,"Select: ",0
    sub_sel byte "1.Subtract from Matrix A?",10,"2.Subtract from Matrix B?",10,"Select: ",0
    mul_sel byte "1.Multiply Matrix A?",10,"2.Multiply Matrix B?",10,"Select: ",0
    trans_sel byte "1.Transpose Matrix A?",10,"2.Transpose Matrix B?",10,"Select: ",0
    det_sel byte "1.Determinant of Matrix A?",10,"2.Determinant of Matrix B?",10,"Select: ",0
    
    ; Operation constants
    divisor_val byte ?
    addend_val byte ?
    subtrahend_val byte ?
    multiplier_val byte ?
    det_label byte "Determinant = ",0
    determinant_val byte ?
    cofactor_a byte ?
    cofactor_b byte ?
    cofactor_c byte ?
    col_one byte ?
    col_two byte ?
    col_three byte ?

.code

main PROC 
    call clrscr
    mov eax, blue + (white*16)
    call settextcolor
    lea edx,title_msg
    call writestring
    call crlf
    call crlf
    mov edx,offset main_menu_msg
    call writestring
    call readdec

    cmp eax,1
    je configure_matrix_a

    cmp eax,2
    je configure_matrix_b

    cmp eax,3
    je matrix_addition

    cmp eax,4
    je matrix_subtraction

    cmp eax,5
    je element_square

    cmp eax,6
    je element_cube

    cmp eax,7
    je constant_addition

    cmp eax,8
    je constant_subtraction

    cmp eax,9
    je constant_multiplication

    cmp eax,10
    je constant_division

    cmp eax,11
    je transpose_matrix

    cmp eax,12
    je calculate_determinant_2x2

    cmp eax,13
    je calculate_determinant_3x3

    cmp eax,14
    je view_matrix_a

    cmp eax,15
    je view_matrix_b

    cmp eax,16
    je exit_program

    jmp main

exit_program:
    exit
main ENDP

; Configure Matrix A
configure_matrix_a PROC
    input_dimensions:
    call clrscr
    xor eax,eax
    lea edx,prompt_rows
    call writestring
    call readdec
    cmp al,0
    je zero_error
    cmp al,6
    jg max_error
    mov rows_a,al
    
    mov edx,OFFSET prompt_cols
    call writestring
    call readdec

    cmp al,0
    je zero_error
    cmp al,6
    jg max_error
    mov cols_a,al

    mov bl,rows_a
    mul bl
    movzx ecx,ax
    lea esi,first_matrix
    mov edi,0
    mov ebx,0

    input_loop:
        mov edx,OFFSET mat_a_label
        call writestring
        mov eax,ebx
        call writedec
        mov edx,OFFSET index_sep
        call writestring
        mov eax,edi
        call writedec
        mov edx,offset value_prompt
        call writestring
        inc edi
        call readdec
        mov [esi],al
        inc esi
        mov eax,edi
        cmp al,cols_a
        jne continue_input
        mov edi,0
        inc ebx
        continue_input:
        loop input_loop

        jmp return_to_main

    zero_error:
        lea edx,zero_size_err
        call writestring
        call readchar
        jmp input_dimensions
    max_error:
        lea edx,max_size_err
        call writestring
        call readchar
        jmp input_dimensions

    return_to_main:
        jmp main
        ret
configure_matrix_a ENDP

; Configure Matrix B
configure_matrix_b PROC
    input_dimensions:
    call clrscr
    xor eax,eax
    lea edx,prompt_rows
    call writestring
    call readdec

    cmp al,0
    je zero_error
    cmp al,6
    jg max_error
    mov rows_b,al
    
    mov edx,OFFSET prompt_cols
    call writestring
    call readdec

    cmp al,0
    je zero_error
    cmp al,6
    jg max_error
    mov cols_b,al

    mov bl,rows_b
    mul bl
    movzx ecx,ax
    lea esi,second_matrix
    mov edi,0
    mov ebx,0

    input_loop:
        mov edx,OFFSET mat_b_label
        call writestring
        mov eax,ebx
        call writedec
        mov edx,OFFSET index_sep
        call writestring
        mov eax,edi
        call writedec
        mov edx,offset value_prompt
        call writestring
        inc edi
        call readdec
        mov [esi],al
        inc esi
        mov eax,edi
        cmp al,cols_b
        jne continue_input
        mov edi,0
        inc ebx
        continue_input:
        loop input_loop

        jmp return_to_main

    zero_error:
        lea edx,zero_size_err
        call writestring
        call readchar
        jmp input_dimensions
    max_error:
        lea edx,max_size_err
        call writestring
        call readchar
        jmp input_dimensions

    return_to_main:
        jmp main
        ret
configure_matrix_b ENDP

; Matrix addition
matrix_addition PROC
    call clrscr
    mov al,rows_a
    mov bl,rows_b
    cmp al,bl
    jne size_error
    mov al,cols_a
    mov bl,cols_b
    cmp al,bl
    jne size_error

    mov al,rows_a
    mov bl,cols_a
    mov rows_res,al
    mov cols_res,bl

    mov al,rows_a
    mov bl,cols_a
    mul bl
    movzx ecx,ax
    lea esi,first_matrix
    lea edi,second_matrix
    lea ebx,result_matrix
    xor eax,eax
    xor edx,edx

    addition_loop:
        mov al,[esi]
        mov dl,[edi]
        add al,dl
        mov [ebx],al
        inc esi
        inc edi
        inc ebx
    loop addition_loop
    call display_result_matrix
    
    jmp operation_complete

    size_error:
        mov edx,OFFSET size_mismatch
        call writestring
        call readchar
    operation_complete:
    jmp main
    ret
matrix_addition ENDP

; Matrix subtraction
matrix_subtraction PROC
    call clrscr
    mov eax,green + (white*16)
    call settextcolor

    call clrscr
    mov al,rows_a
    mov bl,rows_b
    cmp al,bl
    jne size_error

    mov al,cols_a
    mov bl,cols_b
    cmp al,bl
    jne size_error
    mov al,rows_a
    mov bl,cols_a

    mov rows_res,al
    mov cols_res,bl
    mov al,rows_a
    mov bl,cols_a
    mul bl
    movzx ecx,ax
    lea esi,first_matrix
    lea edi,second_matrix
    lea ebx,result_matrix
    xor eax,eax
    xor edx,edx

    subtraction_loop:
        mov al,[esi]
        mov dl,[edi]
        sub al,dl
        mov [ebx],al
        inc esi
        inc edi
        inc ebx
    Loop subtraction_loop
    call display_result_matrix
    jmp operation_complete

    size_error:
        lea edx,OFFSET size_mismatch
        call writestring
        call readchar
    operation_complete:
        jmp main
    ret
matrix_subtraction ENDP

; Element-wise square
element_square PROC 
    call clrscr
    mov edx,offset square_sel
    call writestring
    call readdec

    cmp al,1
    je process_matrix_a
    jmp process_matrix_b

    process_matrix_a:
        mov al,rows_a
        mov bl,cols_a
        mov rows_res,al
        mov cols_res,bl
        
        mul bl
        movzx ecx,ax
        lea edi,first_matrix
        lea esi,result_matrix

        square_loop_a:
            mov al,[edi]
            mov bl,[edi]
            mul bl
            mov [esi],al
            inc edi
            inc esi
            loop square_loop_a
        jmp display_result

    process_matrix_b:
        mov al,rows_b
        mov bl,cols_b
        mov rows_res,al
        mov cols_res,bl

        mul bl
        movzx ecx,ax
        lea edi,second_matrix
        lea esi,result_matrix

        square_loop_b:
            mov al,[edi]
            mov bl,[edi]
            mul bl
            mov [esi],al
            inc edi
            inc esi
            loop square_loop_b
        jmp display_result
        
    display_result:
        call display_result_matrix
        jmp main
        ret
element_square ENDP

; Element-wise cube
element_cube PROC
    call clrscr
    mov edx,offset cube_sel
    call writestring
    call readdec

    cmp al,1
    je process_matrix_a
    jmp process_matrix_b

    process_matrix_a:
        mov al,rows_a
        mov bl,cols_a
        mov rows_res,al
        mov cols_res,bl
        
        mul bl
        movzx ecx,ax
        lea edi,first_matrix
        lea esi,result_matrix

        cube_loop_a:
            mov al,[edi]
            mov bl,[edi]
            mul bl
            mul bl
            mov [esi],al
            inc edi
            inc esi
            loop cube_loop_a
        jmp display_result

    process_matrix_b:
        mov al,rows_b
        mov bl,cols_b
        mov rows_res,al
        mov cols_res,bl

        mul bl
        movzx ecx,ax
        lea edi,second_matrix
        lea esi,result_matrix

        cube_loop_b:
            mov al,[edi]
            mov bl,[edi]
            mul bl
            mul bl
            mov [esi],al
            inc edi
            inc esi
            loop cube_loop_b
        jmp display_result
        
    display_result:
        call display_result_matrix
        jmp main
        ret
element_cube ENDP

; Add constant to matrix elements
constant_addition PROC
    lea edx,const_add_prompt
    call writestring
    call readdec
    xor edx,edx
    mov addend_val,al

    mov eax,green + (white*16)
    call settextcolor
    call clrscr
    lea edx,OFFSET add_sel
    call writestring
    call readdec
    
    cmp al,1
    je process_matrix_a
    jmp process_matrix_b

    process_matrix_a:
        mov al,rows_a
        mov bl,cols_a
        mov rows_res,al
        mov cols_res,bl

        mul bl
        movzx ecx,ax
        mov esi,OFFSET result_matrix
        mov edi,OFFSET first_matrix
        add_loop_a:
            mov al,[edi]
            add al,addend_val
            mov [esi],al
            inc edi
            inc esi
        Loop add_loop_a
        jmp display_result

    process_matrix_b:
        mov al,rows_b
        mov bl,cols_b
        mov rows_res,al
        mov cols_res,bl

        mul bl
        movzx ecx,ax
        mov esi,OFFSET result_matrix
        mov edi,OFFSET second_matrix
        add_loop_b:
            mov al,[edi]
            add al,addend_val
            mov [esi],al
            inc edi
            inc esi
        Loop add_loop_b
        
    display_result:
        call display_result_matrix
        jmp main
        ret
constant_addition ENDP

; Subtract constant from matrix elements
constant_subtraction PROC
    lea edx,const_sub_prompt
    call writestring
    call readdec
    xor edx,edx
    mov subtrahend_val,al

    mov eax,green + (white*16)
    call settextcolor
    call clrscr
    lea edx,OFFSET sub_sel
    call writestring
    call readdec
    
    cmp al,1
    je process_matrix_a
    jmp process_matrix_b

    process_matrix_a:
        mov al,rows_a
        mov bl,cols_a
        mov rows_res,al
        mov cols_res,bl

        mul bl
        movzx ecx,ax
        mov esi,OFFSET result_matrix
        mov edi,OFFSET first_matrix
        sub_loop_a:
            mov al,[edi]
            sub al,subtrahend_val
            mov [esi],al
            inc edi
            inc esi
        Loop sub_loop_a
        jmp display_result

    process_matrix_b:
        mov al,rows_b
        mov bl,cols_b
        mov rows_res,al
        mov cols_res,bl

        mul bl
        movzx ecx,ax
        mov esi,OFFSET result_matrix
        mov edi,OFFSET second_matrix
        sub_loop_b:
            mov al,[edi]
            sub al,subtrahend_val
            mov [esi],al
            inc edi
            inc esi
        Loop sub_loop_b
        
    display_result:
        call display_result_matrix
        jmp main
        ret
constant_subtraction ENDP

; Multiply matrix elements by constant
constant_multiplication PROC
    lea edx,const_mul_prompt
    call writestring
    call readdec
    xor edx,edx
    mov multiplier_val,al

    mov eax,red + (white*16)
    call settextcolor
    call clrscr
    lea edx,OFFSET mul_sel
    call writestring
    call readdec
    
    cmp al,1
    je process_matrix_a
    jmp process_matrix_b

    process_matrix_a:
        mov al,rows_a
        mov bl,cols_a
        mov rows_res,al
        mov cols_res,bl

        mul bl
        movzx ecx,ax
        mov esi,OFFSET result_matrix
        mov edi,OFFSET first_matrix
        mul_loop_a:
            mov al,[edi]
            mov bl,multiplier_val
            mul bl
            mov [esi],al
            inc edi
            inc esi
        Loop mul_loop_a
        jmp display_result

    process_matrix_b:
        mov al,rows_b
        mov bl,cols_b
        mov rows_res,al
        mov cols_res,bl

        mul bl
        movzx ecx,ax
        mov esi,OFFSET result_matrix
        mov edi,OFFSET second_matrix
        mul_loop_b:
            mov al,[edi]
            mov bl,multiplier_val
            mul bl
            mov [esi],al
            inc edi
            inc esi
        Loop mul_loop_b
        
    display_result:
        call display_result_matrix
        jmp main
        ret
constant_multiplication ENDP

; Divide matrix elements by constant
constant_division PROC
    lea edx,const_div_prompt
    call writestring
    call readdec
    xor edx,edx
    mov divisor_val,al

    mov eax,red+(white*16)
    call settextcolor
    call clrscr
    lea edx,OFFSET div_sel
    call writestring
    call readdec
    
    cmp al,1
    je process_matrix_a
    jmp process_matrix_b

    process_matrix_a:
        mov al,rows_a
        mov bl,cols_a
        mov rows_res,al
        mov cols_res,bl

        mul bl
        movzx ecx,ax
        mov esi,OFFSET result_matrix
        mov edi,OFFSET first_matrix
        div_loop_a:
            mov al,[edi]
            mov bl,divisor_val
            xor ah,ah
            div bl
            mov [esi],al
            inc edi
            inc esi
        Loop div_loop_a
        jmp display_result

    process_matrix_b:
        mov al,rows_b
        mov bl,cols_b
        mov rows_res,al
        mov cols_res,bl

        mul bl
        movzx ecx,ax
        mov esi,OFFSET result_matrix
        mov edi,OFFSET second_matrix
        div_loop_b:
            mov al,[edi]
            mov bl,divisor_val
            xor ah,ah
            div bl
            mov [esi],al
            inc edi
            inc esi
        Loop div_loop_b
        
    display_result:
        call display_result_matrix
        jmp main
        ret
constant_division ENDP

; Transpose 3x3 matrices
transpose_matrix PROC
    call clrscr
    lea edx,trans_sel
    call writestring
    call readdec

    cmp al,1
    JE process_matrix_a
    JMP process_matrix_b

    process_matrix_a:
        mov al,rows_a
        cmp al,3
        jne size_error

        mov bl,cols_a
        cmp bl,3
        jne size_error

        mov rows_res,al
        mov cols_res,bl
        
        xor eax,eax

        mov al,first_matrix[0]
        mov result_matrix[0],al
        mov al,first_matrix[1]
        mov result_matrix[3],al
        mov al,first_matrix[2]
        mov result_matrix[6],al

        mov al,first_matrix[3]
        mov result_matrix[1],al
        mov al,first_matrix[4]
        mov result_matrix[4],al
        mov al,first_matrix[5]
        mov result_matrix[7],al

        mov al,first_matrix[6]
        mov result_matrix[2],al
        mov al,first_matrix[7]
        mov result_matrix[5],al
        mov al,first_matrix[8]
        mov result_matrix[8],al
        jmp display_result

    process_matrix_b:
         mov al,rows_b
        cmp al,3
        jne size_error

        mov bl,cols_b
        cmp bl,3
        jne size_error

        mov rows_res,al
        mov cols_res,bl
        
        xor eax,eax

        mov al,second_matrix[0]
        mov result_matrix[0],al
        mov al,second_matrix[1]
        mov result_matrix[3],al
        mov al,second_matrix[2]
        mov result_matrix[6],al

        mov al,second_matrix[3]
        mov result_matrix[1],al
        mov al,second_matrix[4]
        mov result_matrix[4],al
        mov al,second_matrix[5]
        mov result_matrix[7],al

        mov al,second_matrix[6]
        mov result_matrix[2],al
        mov al,second_matrix[7]
        mov result_matrix[5],al
        mov al,second_matrix[8]
        mov result_matrix[8],al
        jmp display_result

    size_error:
        lea edx,size_mismatch
        call writestring
        call readchar
        jmp return_to_main
    display_result:
        call display_result_matrix
        jmp main
    return_to_main:
        jmp main
        ret
transpose_matrix ENDP

; Display result matrix
display_result_matrix PROC
    mov al,rows_res
    mov bl,cols_res
    mul bl
    movzx ecx,ax
    lea esi,result_matrix
    mov bl,0
    xor eax,eax
    print_loop:
        mov al,[esi]
        call writedec
        mov al,32
        call writechar
        inc bl
        cmp bl,cols_res
        jne next_col
        mov bl,0
        call crlf
        next_col:
        inc esi
    loop print_loop
    call readchar
    ret
display_result_matrix ENDP

; Calculate determinant of 2x2 matrices
calculate_determinant_2x2 PROC
    call clrscr
    lea edx,det_sel
    call writestring
    call readdec

    cmp al,1
    je process_matrix_a
    jmp process_matrix_b

    process_matrix_a:
        mov al,rows_a
        cmp al,2
        jne size_error
        mov bl,cols_a
        cmp bl,2
        jne size_error
        lea esi,first_matrix
        lea edi,first_matrix
        jmp calculate_2x2
    process_matrix_b:
        mov al,rows_b
        cmp al,2
        jne size_error
        mov bl,cols_b
        cmp bl,2
        jne size_error
        lea esi,second_matrix
        lea edi,second_matrix
        jmp calculate_2x2

    calculate_2x2:
        mov al,[esi]
        add esi,3
        mov bl,[esi]
        mul bl
        mov cl,al

        inc edi
        mov al,[edi]
        inc edi
        mov bl,[edi]
        mul bl
        sub cl,al
        mov determinant_val,cl
        lea edx,det_label
        call writestring
        mov al,determinant_val
        call writedec
        call readchar
        jmp return_to_main
    size_error:
        mov edx,OFFSET size_mismatch
        call writestring
        call readchar
    return_to_main:
        jmp main
        ret
calculate_determinant_2x2 ENDP

; View Matrix A
view_matrix_a PROC
    call clrscr
    mov al,rows_a
    mov bl,cols_a
    mul bl
    movzx ecx,ax
    lea esi,first_matrix
    mov bl,0
    xor eax,eax
    print_loop:
        mov al,[esi]
        call writedec
        mov al,32
        call writechar
        inc bl
        cmp bl,cols_a
        jne next_col
        mov bl,0
        call crlf
        next_col:
        inc esi
    loop print_loop
    call readchar
    jmp main
    ret
view_matrix_a ENDP

; View Matrix B
view_matrix_b PROC
    call clrscr
    mov al,rows_b
    mov bl,cols_b
    mul bl
    movzx ecx,ax
    lea esi,second_matrix
    mov bl,0
    xor eax,eax
    print_loop:
        mov al,[esi]
        call writedec
        mov al,32
        call writechar
        inc bl
        cmp bl,cols_b
        jne next_col
        mov bl,0
        call crlf
        next_col:
        inc esi
    loop print_loop
    call readchar
    jmp main
    ret
view_matrix_b ENDP

; Calculate determinant of 3x3 matrices
calculate_determinant_3x3 PROC
    call clrscr
    lea edx,det_sel
    call writestring
    call readdec

    cmp al,1
    je process_matrix_a
    jmp process_matrix_b

    process_matrix_a:
        mov al,rows_a
        cmp al,3
        jne size_error
        mov bl,cols_a
        cmp bl,3
        jne size_error
        lea esi,first_matrix
        lea edi,first_matrix
        lea edx,first_matrix
        jmp calculate_3x3
    process_matrix_b:
        mov al,rows_b
        cmp al,3
        jne size_error
        mov bl,cols_b
        cmp bl,3
        jne size_error
        lea esi,second_matrix
        lea edi,second_matrix
        lea edx,second_matrix
        jmp calculate_3x3

    calculate_3x3:
        mov al,[esi]
        mov col_one,al
        add esi,4
        mov al,[esi]
        add esi,4
        mov bl,[esi]
        mul bl
        mov cl,al

        sub esi,3
        mov al,[esi]
        add esi,2
        mov bl,[esi]
        mul bl
        sub cl,al
        mov al,cl
        mov bl,col_one
        mul bl
        mov cofactor_a,al

        inc edi
        mov al,[edi]
        mov col_two,al
        add edi,2
        mov al,[edi]
        add edi,5
        mov bl,[edi]
        mul bl
        mov cl,al

        sub edi,3
        mov al,[edi]
        inc edi
        mov bl,[edi]
        mul bl
        sub cl,al
        mov al,cl
        mov bl,col_two
        mul bl
        mov cofactor_b,al

        add edx,2
        mov al,[edx]
        mov col_three,al
        inc edx
        mov al,[edx]
        add edx,4
        mov bl,[edx]
        mul bl
        mov cl,al

        sub edx,3
        mov al,[edx]
        add edx,2
        mov bl,[edx]
        mul bl
        sub cl,al
        mov al,cl
        mov bl,col_three
        mul bl
        mov cofactor_c,al

        xor eax,eax

        mov al,cofactor_a
        mov bl,cofactor_b
        mov cl,cofactor_c

        sub al,bl
        add al,cl
        mov determinant_val,al
        lea edx,det_label
        call writestring
        call writedec
        call readchar

        jmp return_to_main
    size_error:
        mov edx,OFFSET size_mismatch
        call writestring
        call readchar
    return_to_main:
        jmp main
        ret
calculate_determinant_3x3 ENDP

END main