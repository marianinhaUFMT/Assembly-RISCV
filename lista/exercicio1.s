# Determine o comprimento de uma string no estilo C adicionando 1 a um acumulador 
# ate encontrar o terminador ‘\0’. A string deve ser inicializada estaticamente na area 
# de dados globais. O programa deve mostrar o resultado com a chamada de sistema 'write'.

.section .data
    string: .asciz "Hello, world!"

.section .text
    .globl _start

_start:
    # conta o comprimento da string
    la s0, string       # endereço base da string
    li s1, 0            # contador

for:
    lb t1, 0(s0)            # carrega byte atual
    beq t1, zero, done      # se for '\0', sai do loop
    addi s1, s1, 1          # incrementa contador
    addi s0, s0, 1          # proximo caractere
    j for

done:
    # converte o comprimento (s1) para ASCII empilhando os digitos
    li t1, 10           # base 10
    mv t2, sp           # salva o inicio da pilha
    li t5, 0            # contador de digitos

converte:
    rem t4, s1, t1           # calcula resto (s1 % 10)
    div s1, s1, t1           # divide s1 por 10
    addi t4, t4, 48          # converte para ASCII ('0' = 48)
    addi sp, sp, -1          # move a pilha para baixo (1 byte por digito)
    sb t4, 0(sp)             # empilha o digito como byte
    addi t5, t5, 1           # incrementa contador
    bne s1, zero, converte   # continua se s1 != 0

    # write
    li a7, 64           
    li a0, 1            # file descriptor 1 (stdout)
    mv a1, sp           # endereco do numero convertido (topo da pilha)
    mv a2, t5           # tamanho = numero de digitos
    ecall               

    # restaura a pilha
    mv sp, t2           

    # exit
    li a7, 93          
    li a0, 0            
    ecall               
    
