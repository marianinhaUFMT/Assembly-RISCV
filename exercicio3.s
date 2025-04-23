# Escreva uma funcao que faça uma copia de uma string estilo C para outra. A copia 
# deve ser o reverso da string original. A funcao deve retornar o numero de bytes 
# copiados. Teste a funcao imprimindo a copia usando a chamada de sistema 'write'.

.section .rodata
    src: .asciz "\nHello, world!"     

.section .data
    dest: .space 40                   # espaço para a string invertida

.section .text
    .globl _start
    
_start:
    la a0, src               # endereco da string de origem
    la a1, dest              # endereco da string invertida
    jal ra, reverso_copia    # chama a funcao

    # write
    mv a2, a0               # numero de bytes copiados (retornado em a0)
    li a7, 64              
    li a0, 1                # stdout
    la a1, dest             # endereco inicial da string invertida
    ecall

    # exit
    li a7, 93
    li a0, 0
    ecall

# funcao reverso_copia(in: a0 = endereco da string, a1 = espaco para string invertida | out: a0 = n bytes copiados)
reverso_copia:
    mv t0, a0               # endereco da origem
    mv t1, a1               # endereco do destino
    li t2, 0                # contador de comprimento

    cont_tamanho:
        lb t3, 0(t0)            # carrega byte da origem
        beq t3, zero, reverso   # se for '\0', vai para a inversao
        addi t0, t0, 1          # avança caractere
        addi t2, t2, 1          # incrementa contador
        j cont_tamanho

    reverso:
        addi t0, t0, -1              # volta ao ultimo caractere antes do '\0'
    copia_loop:
        lb t3, 0(t0)                 # carrega byte da origem
        sb t3, 0(t1)                 # armazena no destino
        addi t0, t0, -1              # retrocede caractere
        addi t1, t1, 1               # avança para o proximo byte do espaco
        addi t2, t2, -1              # decrementa contador
        bgt t2, zero, copia_loop     # continua enquanto houver caracteres

        sb zero, 0(t1)          # adiciona o terminador '\0'
        mv a0, t1               # retorna o numero de bytes copiados (incluindo '\0')
        sub a0, t1, a1          # calcula o comprimento da string copiada
        jr ra                   
    