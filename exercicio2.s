# Repita o exercicio 1, implementando o que eh pedido na forma de uma funcao. 
# Teste a funcao passando como parametro a string global.

.section .data
    string: .asciz "Hello, world!"    

.section .text
    .globl _start

_start:
    la a0, string        # passa endereco da string para strsize
    call strsize         # chama a funcao
    
    # converte o comprimento para ASCII e imprime
    li t1, 10           # base 10
    mv t2, sp           # salva o inicio da pilha
    li t5, 0            # contador

convert:
    rem t4, a0, t1          # calcula resto (a0 % 10)
    div a0, a0, t1          # divide a0 por 10
    addi t4, t4, 48         # converte para ASCII ('0' = 48)
    addi sp, sp, -1         # move a pilha para baixo (1 byte por digito)
    sb t4, 0(sp)            # empilha o digito como byte
    addi t5, t5, 1          # incrementa contador
    bne a0, zero, convert   # continua se a0 != 0

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

# funcao strsize(in: a0 = endereco da string | out: a0 = comprimento)
strsize:
    li t1, 0            # contador de comprimento

    loop:
        lb t2, 0(a0)        # carrega byte atual
        beq t2, zero, done  # se for '\0', sai do loop
        addi t1, t1, 1      # incrementa contador
        addi a0, a0, 1      # proximo caractere
        j loop

    done:
        mv a0, t1           # retorna o comprimento
        jr ra               
