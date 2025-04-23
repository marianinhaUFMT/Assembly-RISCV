Trabalharemos com Linux Ubuntu versão 20.04 ou superior. Se você tem uma versão do Ubuntu mais antiga ou trabalha com o Windows, virtualize o ambiente requerido com multipass: https://multipass.run.

▪ Multipass é uma ferramenta leve e multiplataforma desenvolvida pela Canonical (empresa por trás do Ubuntu) para gerenciar máquinas virtuais.

▪ Se estiver trabalhando com o Windows é necessário o Windows 10 Pro/Enterprise/Education versão 1803 ou posterior. Caso contrário, além do multipass, você vai precisar instalar o virtualbox.

▪ Caso precise virtualizar, seja no Windows, Linux mais antigo ou Mac, proceda da seguinte forma para instalar a máquina virtual:
  1. Instale o multipass.
  2. Abra um terminal e veja as images Ubuntu disponíveis:
     
      $ multipass find
  2. Crie a máquina virtual (Ubuntu Noble 20.04) chamada de riscv digitando o comando abaixo no terminal.
     
      $ multipass launch noble --name riscv
▪ Concluída a instalação da máquina virtual, realize os seguintes testes:

  ❑ Liste o status das VMs presentes no seu computador:

      $ multipass list
      
  ❑ Inicialize a máquina virtual riscv:
  
      $ multipass start riscv
      
  ❑ Abra um shell na máquina virtual riscv:
  
      $ multipass shell riscv
      
  ❑ Para desligar a máquina virtual riscv:
  
      $ multipass stop riscv

▪ Com o Ubuntu instalando, precisamos instalar os pacotes necessários ao desenvolvimento da disciplina.

▪ Execute o comando abaixo em um terminal da VM instalada:

      $ sudo apt-get install gcc-riscv64-linux-gnu build-essential gdb-multiarch qemu-systemmisc qemu-user binutils-riscv64-unknown-elf libc6-riscv64-cross

▪ Isso instalará várias ferramentas, dentre elas a família riscv64-unknown-gnue a família riscv64-linux-gnu

Geração de Código Nativo RV32i

▪ A linha de comando a seguir ilustra como gerar código nativo RISC-V usando o GNU assembler riscv64-unknown-elf-as.

      $ riscv64-unknown-elf-as -mabi=ilp32 -march=rv32im main.s -o main.o

▪ O comando a seguir ilustra como a ferramenta riscv64-unknown-elfld vincula os arquivos objeto main.o e mylib.o e gera o arquivo executável main.exe

▪ A opção -m elf32lriscv especifica que o formato ELF de 32 bits com arquitetura RISC-V será utilizado para o arquivo de saída.

      $ riscv64-unknown-elf-ld -m elf32lriscv main.o -o main.exe

▪ Para executar, usamos o QEMU:

      $ qemu-riscv32 main.exe
