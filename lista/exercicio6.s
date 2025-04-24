# Escreva uma funcao para determinar se um numero inteiro eh impar ou par.
# A funcao deve retornar 1 se o numero par e 0 se o numero for impar.

.section .data
    num: .word 30
    par: .asciz "1\n"
    impar: .asciz "0\n"

.section .text
    .globl _start

_start:
    .option push
    .option norelax
    la gp, __global_pointer$
    .option pop

    # carrega o numero de entrada
    la t0, num
    lw a0, 0(t0)             # a0 = valor de num

    # chama a funcao que retorna se eh par ou impar
    jal ra, eh_par

    # coloca o a0 (que tem "1" ou "0") no a1 para impressao
    mv a1, a0               

    li a7, 64               # syscall write
    li a0, 1                # file descriptor 1 (stdout)
    li a2, 2                # tamanho da string
    ecall

    # exit
    li a7, 93
    li a0, 0
    ecall

# Funcao: eh_par (a0 = número, retorna a0 = 1 se par, a0 = 0 se impar)
eh_par:
    li t1, 2
    rem t2, a0, t1                    # t2 = a0 % 2
    beq t2, zero, return_par          # Se t2 == 0, eh par
    la a0, impar
    jr ra
return_par:
    la a0, par
    jr ra
