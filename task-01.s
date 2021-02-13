.global find_max_zero_column
.extern puts
.extern printf

.section .rodata
.Failure:
	.asciz "Не найдено 0 в матрице"
.Success:
    .asciz "Максимальная вертикальная линия начинается в позиции {%llu, %llu}, длины %llu\n"

.text
check_column_const:
    pushq   %rbp
    mov     %rsp, %rbp

    pushq   %rdi                # -8  указатель на матрицу 
    pushq   %rsi                # -16 кол-во строк n
    pushq   %rdx                # -24 кол-во столбцов m
    pushq   %rcx                # -32 позиция i
    pushq   %r8                 # -40 позиция j
    pushq   $0                  # -48 длина столбика, который нашли
    jmp     .check_count

.increase_count:
    incq    -48(%rbp)
    incq    -32(%rbp)
.check_count:
    movq    -32(%rbp), %rax
    cmp     -16(%rbp), %rax
    jnb     .out_check

    movq    -32(%rbp), %rcx
    movq    -24(%rbp), %rax
    mul     %rcx                # здесь может быть переволнение, если размер массива больше uint64          
    addq    -40(%rbp), %rax

    movq    -8(%rbp), %rcx
    movb    (%rcx, %rax, 1), %al

    cmpb    $48, %al
    je      .increase_count

.out_check:
    movq    -48(%rbp), %rax
    mov     %rbp, %rsp
    popq    %rbp
    ret

find_max_zero_column:
    pushq   %rbp
    mov     %rsp, %rbp

    pushq   %rdx                # -8  указатель на матрицу 
    pushq   %rdi                # -16 кол-во строк n
    pushq   %rsi                # -24 кол-во столбцов m
    pushq   $0                  # -32 max
    sub     $32, %rsp

    movq    $0, -40(%rbp)       # -40 i
    jmp     .check_i

.cycle_i:                           # начало цикла по i
    movq    $0, -48(%rbp)       # -48 j
    jmp     .check_j
.cycle_j:                           # начало цикла по j
    movq    -8(%rbp), %rdi          # вызываем check_column_const
    movq    -16(%rbp), %rsi
    movq    -24(%rbp), %rdx
    movq    -40(%rbp), %rcx
    movq    -48(%rbp), %r8
    call check_column_const

    cmp     -32(%rbp), %rax
    jna     .increase_j            # если длина максимальной строки не больше max


.set_new_max:
    movq    %rax, -32(%rbp)
    movq    -40(%rbp), %rax         # записываем позицию i
    movq    %rax, -56(%rbp)
    movq    -48(%rbp), %rax         # записываем позицию j
    movq    %rax, -64(%rbp)

.increase_j:
    incq    -48(%rbp)
.check_j:
    mov     -48(%rbp), %rax
    cmp     -24(%rbp), %rax
    jb      .cycle_j

.increase_i:
    incq    -40(%rbp)
.check_i:
    mov     -40(%rbp), %rax
    cmp     -16(%rbp), %rax
    jb      .cycle_i

# что делать после цикла

    cmpq    $0, -32(%rbp)
    jne     .success

.failure:                           # Что если не нашли
    mov    $.Failure, %rdi
    call   puts
    jmp    .out_find

.success:                           # Что если нашли
    mov    $.Success, %rdi
    movq   -56(%rbp), %rax
    movq   %rax, %rsi
    movq   -64(%rbp), %rdx
    movq   -32(%rbp), %rcx
    movq   $0, %rax
    call   printf

.out_find:
    mov     %rbp, %rsp
    popq    %rbp
    ret
