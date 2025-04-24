# Escreva uma funcao que ordene (em ordem crescente) os elementos de um array de inteiros. A funcao deve receber como parametros 
# o array e o numero de elementos que o compoe. Use o algoritmo bubble sort para fazer a ordenacao. Mostre o resultado na tela
# do computador usando a chamada de sistema write. Para isso, use a funcao de conversao especificada no exercicio 4.

.section .data
    array: .word 5, 3, 8, 4, 7, -1, 2, 6, 0, 9   # array a ser ordenado
    n: .word 10                                  # n elementos
    buffer: .space 20                            # espaco para os num convertidos
    espaco: .string " "                          # so para separar os numeros para impressao

.section .text
.globl _start

_start:
    .option push
    .option norelax
    la gp, __global_pointer$
    .option pop

    # chama a funcao que ordena o array
    la a0, array
    lw a1, n
    jal ra, bubble_sort

    # chama a funcao que imprime o array ordenado
    la a0, array
    lw a1, n
    jal ra, print_array

    # exit
    li a7, 93
    li a0, 0
    ecall

# funcao: bubble_sort (in: a0 = endereco do array, a1 = n elementos | out: a0 = array ordenado)
bubble_sort:
    addi sp, sp, -16        # reserva espaco na pilha
    sw ra, 12(sp)          
    sw s0, 8(sp)           
    sw s1, 4(sp)            
    sw s2, 0(sp)            

    mv s0, a0                   # s0 = endereco do array
    mv s1, a1                   # s1 = n elementos
    li s2, 0                    # s2 = i do loop externo

    loop_externo:
        addi t0, s1, -1             # t0 = n-1
        bge s2, t0, fim_bubble      # Se i >= n-1, termina
        li t1, 0                    # t1 = j (loop interno)

        loop_interno:
            sub t2, t0, s2              # t2 = n-1-i
            bge t1, t2, fim_interno     # if j >= n-1-i then i++

            # calcula enderecos de array[j] e array[j+1]
            slli t3, t1, 2          # t3 = j*4 (offset)
            add t4, s0, t3          # t4 = &array[j] (base+offset)
            addi t5, t4, 4          # t5 = &array[j+1]

            lw t6, 0(t4)            # t6 = array[j]
            lw t2, 0(t5)            # t2 = array[j+1]

            ble t6, t2, sem_troca   # se array[j] <= array[j+1], nao troca

            # faz o swap (troca)
            sw t2, 0(t4)            # array[j] = array[j+1]
            sw t6, 0(t5)            # array[j+1] = array[j]

            sem_troca:
                addi t1, t1, 1          # j++
                j loop_interno

        fim_interno:
            addi s2, s2, 1          # i++
            j loop_externo

fim_bubble:
    # restaura os registradores
    lw ra, 12(sp)           
    lw s0, 8(sp)            
    lw s1, 4(sp)           
    lw s2, 0(sp)            
    addi sp, sp, 16         # libera pilha
    jr ra

# funcao: print_array (a0 = endereco do array, a1 = numero de elementos)
print_array:
    # salva registradores
    addi sp, sp, -16        # reserva espaço na pilha
    sw ra, 12(sp)           
    sw s0, 8(sp)            
    sw s1, 4(sp)            
    sw s2, 0(sp)            

    mv s0, a0               # s0 = endereco do array
    mv s1, a1               # s1 = numero de elementos
    li s2, 0                # s2 = contador

    loop_print:
        bge s2, s1, fim_print   # se contador >= n, termina

        # carrega elemento e chama funcao para converter para string
        slli t0, s2, 2          # t0 = s2*4 (offset)
        add t0, s0, t0          # t0 = &array[s2]
        lw a0, 0(t0)            # a0 = array[s2]
        la a1, buffer           # a1 = endereco do buffer
        jal ra, int_str         # converte inteiro para string

        # write para numero
        li a7, 64               
        li a0, 1                # fd = 1 (stdout)
        # a1 ja contem o endereco da string
        mv a2, a3               # a2 = tamanho da string (retornado por int_str)
        ecall                   

        # write para espaco
        li a7, 64               
        li a0, 1                # fd = 1 (stdout)
        la a1, espaco           # endereco do espaço
        li a2, 1                # tamanho do espaço
        ecall

        addi s2, s2, 1          # contador++
        j loop_print

fim_print:
    # restaura os registradores
    lw ra, 12(sp)          
    lw s0, 8(sp)            
    lw s1, 4(sp)            
    lw s2, 0(sp)            
    addi sp, sp, 16         # libera pilha
    jr ra

# funcao: int_str (a0 = inteiro, a1 = endereco do buffer | out: a1 = inicio da string, t1 = tamanho)
int_str:
    mv t0, a0                       # salva numero original
    mv t2, a1                       # t2 = endereco do buffer
    addi t2, t2, 19                 # ponteiro para o fim do buffer (20-1)
    li t3, 0                        # contador de digitos
    li t4, 0                        # flag negativo

    blt t0, zero, neg_num
    j conversao

neg_num:
    li t4, 1                        # marca que eh negativo
    neg t0, t0                      # torna positivo para conversao

conversao:
    li t5, 10

    conversao_loop:
        rem t6, t0, t5              # t6 = t0 % 10
        addi t6, t6, 48             # converte para ASCII
        sb t6, 0(t2)                # armazena no buffer
        addi t2, t2, -1             # move ponteiro para tras
        addi t3, t3, 1              # incrementa contador
        div t0, t0, t5              # t0 = t0 / 10
        bne t0, zero, conversao_loop

    beq t4, zero, fim               # se nao eh negativo, pula
    li t6, 45                       # ASCII de '-'
    sb t6, 0(t2)                    # armazena '-'
    addi t2, t2, -1                 # move ponteiro para tras
    addi t3, t3, 1                  # incrementa contador

fim:
    addi t2, t2, 1                  # Ajusta ponteiro para primeiro caractere util
    mv a1, t2                       # a1 = inicio da string
    mv a3, t3                       # a3 = numero de caracteres
    jr ra
