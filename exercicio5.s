# Escreva uma funcao para converter uma string para inteiro. O numero deve ser 
# positivo ou negativo. Para testar capture a string do teclado, usando a chamada de 
# sistema read (numero 63) e faça o tratamento apropriado depois imprima a string

.section .data
    buffer: .space 20         # entrada do usuario
    out_buffer: .space 12     # saida (int -> string)

.section .text
    .globl _start

_start:
    .option push
    .option norelax
    la gp, __global_pointer$
    .option pop

    # read entrada
    li a7, 63
    li a0, 0
    la a1, buffer
    li a2, 20
    ecall

    # conversao string -> inteiro
    la a0, buffer
    jal ra, str_int

    # conversao inteiro -> string
    la a1, out_buffer
    jal ra, int_str

    # write resultado
    li a7, 64
    li a0, 1
    mv a2, t1
    ecall

    # exit
    li a7, 93
    li a0, 0
    ecall

# funcao: str_int (in: a0 = endereço da string | out: a0 = inteiro)
str_int:
    mv t0, a0         # ponteiro na string
    li t1, 0          # acumulador
    li t2, 0          # flag negativo
    li s1, 10

    lb t3, 0(t0)
    li t4, 45         # '-' (caso o primeiro caractere seja '-', ou seja, um numero negativo)
    beq t3, t4, negativo
    j digitos

negativo:
    li t2, 1
    addi t0, t0, 1    # avança para o proximo caractere

    digitos:
        lb t3, 0(t0)
        beq t3, t4, done

        li t5, 48         # '0'
        li t6, 57         # '9'
        blt t3, t5, done        # se for menor que '0', sai
        bgt t3, t6, done        # se for maior que '9', sai

        addi t3, t3, -48  # caractere -> numero
        mul t1, t1, s1
        add t1, t1, t3
        addi t0, t0, 1
        j digitos

done:
    beq t2, zero, positivo
    neg t1, t1

positivo:
    mv a0, t1
    jr ra

# funcao: int_str (in: a0 = int, a1 = endereço do buffer | out: a1 = inicio da string, t1 = tamanho)
int_str:
    mv t0, a0
    addi t2, a1, 11     # fim do buffer
    li t3, 0            # contador
    li t4, 0            # flag negativo

    blt t0, zero, neg_flag
    j conversao

neg_flag:
    li t4, 1
    neg t0, t0

conversao:
    li t5, 10

    conversao_loop:
        rem t6, t0, t5
        addi t6, t6, 48
        sb t6, 0(t2)
        addi t2, t2, -1
        addi t3, t3, 1
        div t0, t0, t5
        bne t0, zero, conversao_loop

    beq t4, zero, fim
    li t6, 45
    sb t6, 0(t2)
    addi t2, t2, -1
    addi t3, t3, 1

fim:
    addi t2, t2, 1
    mv a1, t2
    mv t1, t3
    jr ra
