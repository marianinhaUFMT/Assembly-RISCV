# Implemente uma funcao iterativa que receba um inteiro n e calcule o n-esimo numero da serie de Fibonacci

.section .rodata
    n: .word 10                            # F(n) (exemplo: F(10) = 55)
.section .data
    buffer: .space 20                      # buffer para conversao de inteiro para string

.section .text
    .globl _start

_start:

    # chama fibonacci
    lw a0, n                # a0 = n
    jal ra, fibonacci       # Calcula F(n), resultado em a0

    # chama funcao para converter inteiro para string
    mv t0, a0               # salva resultado
    la a1, buffer           # a1 = endereco do buffer
    jal ra, int_to_str      # converte F(n) para string

    # write
    li a7, 64               
    li a0, 1                # fd = 1 (stdout)
    mv a2, a3               # a2 = tamanho da string (retornado por int_to_str)
    ecall                   # a1 já contehm o endereco da string

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

    # inicializa variaveis para iteracao
    li t0, 0                    # t0 = F(i-2) = 0
    li t1, 1                    # t1 = F(i-1) = 1
    mv t2, a0                   # t2 = contador (n)
    li t3, 2                    # t3 = i (começa em 2)

fib_loop:
    bgt t3, t2, fib_done        # se i > n, termina
    add t4, t0, t1              # t4 = F(i) = F(i-2) + F(i-1)
    mv t0, t1                   # F(i-2) = F(i-1)
    mv t1, t4                   # F(i-1) = F(i)
    addi t3, t3, 1              # i++
    j fib_loop

fib_done:
    mv a0, t1                   # a0 = F(n)
    jr ra

base_zero:
    li a0, 0
    jr ra

base_um:
    li a0, 1
    jr ra

# funcao: int_to_str (a0 = inteiro, a1 = endereco do buffer | out: a1 = início da string, a3 = tamanho)
int_to_str:
    mv t0, a0               # salva numero original
    mv t2, a1               # t2 = endereco do buffer
    addi t2, t2, 19         # ponteiro para o fim do buffer (20-1)
    li t3, 0                # contador de digitos
    li t4, 0                # flag negativo

    blt t0, zero, neg_num
    j conversao

neg_num:
    li t4, 1                # marca que eh negativo
    neg t0, t0              # orna positivo para conversao

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
