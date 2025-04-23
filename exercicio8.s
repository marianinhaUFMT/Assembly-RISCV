# Escreva uma funcao que retorne a soma dos elementos de um array de inteiros. A 
# funcao deve receber como parametros o array e o numero de elementos que o 
# compoe. A funcao deve imprimir o resultado na tela. Para isso use a funcao de 
# conversao definida no exercicio 4.

.section .data
    array: .word 1, 2, 3, 4, -5   # array de inteiros
    size: .word 5                 # numero de elementos no array
    buffer: .space 12             # espaco para a string de saida

.section .text
    .globl _start

_start:
    .option push
    .option norelax
    la gp, __global_pointer$
    .option pop

    la a0, array           # a0 = endereço do array
    la t0, size
    lw a1, 0(t0)           # a1 = tamanho do array

    # chama funcao de soma
    jal ra, soma_array     # resultado vai para a0

    # chama funcao para converter a soma para string
    la a1, buffer
    jal ra, int_to_str

    # write
    li a7, 64              
    li a0, 1               # stdout
    mv a2, a3              # comprimento da string
    ecall

    # exit
    li a7, 93
    li a0, 0
    ecall

# funcao: soma_array (in: a0 = endereço do array, a1 = tamanho | out: a0 = soma dos elementos)
soma_array:
    mv t0, a0              # t0 = ponteiro para o array
    mv t1, a1              # t1 = criterio de parada
    li t2, 0               # acumulador (soma)

    soma_loop:
        beq t1, zero, soma_fim      # se n == 0, fim
        lw t3, 0(t0)           # carrega elemento do array
        add t2, t2, t3         # soma ao total
        addi t0, t0, 4         # proximo elemento
        addi t1, t1, -1        # decrementa n
        j soma_loop

soma_fim:
    mv a0, t2              # retorna soma em a0
    jr ra

# funcao: int_to_str (a0 = int, a1 = endereço do buffer | out: a1 = início da string, a3 = tamanho)
int_to_str:
    mv t0, a0                # salva numero original
    addi t2, a1, 11          # ponteiro para o fim do buffer
    li t3, 0                 # contador de dígitos
    li t4, 0                 # flag negativo

    blt t0, zero, neg_num
    j conversao

neg_num:
    li t4, 1                 # marca que eh negativo
    neg t0, t0               # torna positivo para conversao

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

    beq t4, zero, fim    # se não eh negativo, pula
    li t6, 45                # ASCII de '-'
    sb t6, 0(t2)
    addi t2, t2, -1
    addi t3, t3, 1

fim:
    addi t2, t2, 1
    mv a1, t2
    mv a3, t3
    jr ra
