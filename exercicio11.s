# Implemente o que eh pedido no exercicio 10 de forma recursiva

.section .rodata
    n: .word 10              # F(n) (exemplo: F(10) = 55)
.section .data
    buffer: .space 20        # buffer para armazenar a string convertida
.section .text
    .globl _start

_start:

    lw a0, n                # a0 = n
    jal ra, fibonacci       # chama fibonnaci (10), resultado em a0

    # chama funcao para converter inteiro para string
    mv t0, a0               # salva o resultado
    la a1, buffer           # a1 = endereco do buffer
    jal ra, int_to_str      # Converte F(n) para string

    # write
    li a7, 64              
    li a0, 1                # fd = 1 (stdout)
    mv a2, a3               # tamanho da string (retornado por int_to_str)
    ecall                   # a1 já contem o endereco da string

    # exit
    li a7, 93
    li a0, 0
    ecall

# funcao: fibonacci (a0 = n | retorno: a0 = F(n))
fibonacci:
    # casos base
    beq a0, zero, base_zero   # se n == 0, retorna 0
    li t0, 1
    beq a0, t0, base_um      # se n == 1, retorna 1

    # salva registradores na pilha
    addi sp, sp, -16            # reserva espaco para ra e s0
    sw ra, 12(sp)               # salva endereco de retorno
    sw s0, 8(sp)                # salva s0 (para n)
    sw s1, 4(sp)                # salva s1 (para F(n-1))

    mv s0, a0                   # salva n em s0

    # F(n-1)
    addi a0, s0, -1             # a0 = n-1
    jal ra, fibonacci           # chama fibonacci(n-1)
    mv s1, a0                   # salva F(n-1) em s1

    # F(n-2)
    addi a0, s0, -2             # a0 = n-2
    jal ra, fibonacci           # chama fibonacci(n-2)

    # soma F(n-1) + F(n-2)
    add a0, s1, a0              # a0 = F(n-1) + F(n-2)

    # Restaura registradores
    lw ra, 12(sp)               
    lw s0, 8(sp)                
    lw s1, 4(sp)                 
    addi sp, sp, 16             # libera pilha

    jr ra                       # retorna com F(n) em a0

base_zero:
    li a0, 0
    jr ra

base_um:
    li a0, 1
    jr ra

# funcao: int_to_str (in: a0 = inteiro, a1 = endereco do buffer | out: a1 = inicio da string, a3 = tamanho)
int_to_str:
    mv t0, a0               # salva numero original
    mv t2, a1               # t2 = endereco do buffer
    addi t2, t2, 19         # aponta para o fim do buffer (20-1)
    li t3, 0                # contador de digitos
    li t4, 0                # flag negativo

    blt t0, zero, neg_num
    j conversao

neg_num:
    li t4, 1                # marca que eh negativo
    neg t0, t0              # torna positivo para conversao

conversao:
    li t5, 10

    conversao_loop:
        rem t6, t0, t5          # t6 = t0 % 10
        addi t6, t6, 48         # converte para ASCII
        sb t6, 0(t2)            # armazena no buffer
        addi t2, t2, -1         # move ponteiro para tras
        addi t3, t3, 1          # incrementa contador
        div t0, t0, t5          # t0 = t0 / 10
        bne t0, zero, conversao_loop

        beq t4, zero, fim_conv  # se nao eh negativo, pula
        li t6, 45               # ASCII de '-'
        sb t6, 0(t2)            # armazena '-'
        addi t2, t2, -1         # move ponteiro para tras
        addi t3, t3, 1          # incrementa contador

fim_conv:
    addi t2, t2, 1          # ajusta ponteiro para primeiro caractere util
    mv a1, t2               # a1 = inicio da string
    mv a3, t3               # a3 = numero de caracteres
    jr ra
    