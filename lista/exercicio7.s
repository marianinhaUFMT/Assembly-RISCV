# Escreva uma funcao que determina o numero de bits 1 recebido como seu primeiro 
# argumento (a0). Por exemplo, se o campo de 32 bits contiver 6 bits 1 bits, entao a 
# funcao deve retornar 6. Escreva um programa de teste para a funcao.

.section .rodata
    num: .word 0xF           # 1111 em binario
.section .data
    buffer: .space 12           

.section .text
    .globl _start

_start:
    # carrega numero da memoria
    la t0, num
    lw a0, 0(t0)                  # a0 = valor de num

    # chama funcao para contar os bits 1
    jal ra, contar_bits          # a0 = numero de bits 1

    # chama funcao para converter o contador para string
    la a1, buffer                 # a1 = endereço do buffer
    jal ra, int_string           # converte a0 para string no buffer

    # write
    li a7, 64                     
    li a0, 1                      # fd = 1 (stdout)
    mv a2, a3                     # numero de caracteres
    ecall

    # exit
    li a7, 93
    li a0, 0
    ecall

# funcao: contar_bits (entrada: a0 = numero de 32 bits | saida: a0 = quantidade de bits 1)
contar_bits:
    li t1, 0                # contador
    li t2, 32               # numero de bits
    for:
        andi t3, a0, 1          # t3 = a0 & 1
        add t1, t1, t3          # soma ao contador
        srli a0, a0, 1          # a0 >>= 1
        addi t2, t2, -1
        bne t2, zero, for

        mv a0, t1               # retorna o contador em a0
        jr ra

# funcao: int_string (in: a0 = inteiro, a1 = endereço do buffer | out: a1 = inicio da string, a3 = tamanho)
int_string:
    mv t0, a0
    addi t2, a1, 11         # ponteiro para o final do buffer
    li t3, 0                # contador de digitos

    li t5, 10               # base 10 para conversão

    conversao:
        rem t6, t0, t5          # t6 = t0 % 10
        addi t6, t6, 48         # converte para ASCII
        sb t6, 0(t2)
        addi t2, t2, -1         # retrocede para o proximo bit mais significativo
        addi t3, t3, 1
        div t0, t0, t5          # t0 = t0 / 10 (remove o digito menos significativo)
        bne t0, zero, conversao

    addi t2, t2, 1          # ajusta ponteiro para o primeiro caractere util
    mv a1, t2               # coloca o início da string no primeiro argumento (a1)
    mv a3, t3               # tamanho da string (contador)
    jr ra
