# Escreva uma funcao que converta um inteiro (32 bits, complemento de 2) para string. 
# Para testar a funcao, imprima o resultado convertido.

.section .rodata
    num: .word -123        # numero de entrada

.section .data
    buffer: .space 12      # espaco suficiente para um int32 (-2147483648) + \n + \0

.section .text
    .globl _start

_start:

    la t0, num               # carrega o endereço de 'num'
    lw a0, 0(t0)             # carrega o valor armazenado em 'num' para a0
    la a1, buffer            # endereço do buffer (passa para a funcao)
    jal ra, int_str          # chama a funcao de conversao

    # write(fd=1, buf=a1, count=a3)
    li a7, 64  
    li a0, 1                 # fd = 1 (stdout)
    mv a2, a3                # comprimento da string convertida              
    ecall

    # exit
    li a0, 0
    li a7, 93
    ecall

# funcao: int_str (a0 = int, a1 = endereço do buffer | a1 = end do buffer, a3 = tamanho)
int_str:
    mv t0, a0                # salva numero original em t0
    la t2, buffer            # ponteiro para o buffer
    addi t2, t2, 11          # ajusta o ponteiro para o fim do buffer
    li t3, 0                 # contador de digitos

    li t4, 0                 # flag de sinal negativo
    blt a0, zero, neg_num
    j conversao
neg_num:
    li t4, 1                 # define flag de numero negativo
    neg a0, a0               # torna o numero positivo para conversao

conversao:
    li t5, 10

    conversao_loop:
        rem t6, a0, t5           # t6 = a0 % 10
        addi t6, t6, 48          # conversao para caractere ASCII
        sb t6, 0(t2)             # armazena no buffer
        addi t2, t2, -1
        addi t3, t3, 1
        div a0, a0, t5           # a0 = a0 / 10
        bne a0, zero, conversao_loop

    beq t4, zero, fim    # se eh positivo, pula
    li t6, 45                     # ASCII de '-'
    sb t6, 0(t2)
    addi t2, t2, -1
    addi t3, t3, 1

fim:
    addi t2, t2, 1           # ajusta ponteiro para primeiro caractere util
    mv a1, t2
    mv a3, t3                # a3 = numero de caracteres
    jr ra
    
