.text
    # Instruções de aritmética inteira
    addi x1, x0, 10        # x1 = 10
    addi x2, x0, 20        # x2 = 20
    add  x3, x1, x2        # x3 = 30
    sub  x4, x2, x1        # x4 = 10
    xor  x5, x1, x2        # x5 = 30
    or   x6, x1, x2        # x6 = 30
    and  x7, x1, x2        # x7 = 0
    sll  x8, x1, x2        # x8 = 10 << 20
    srl  x9, x2, x1        # x9 = 20 >> 10
    sra  x10, x2, x1       # x10 = 20 >> 10
    slt  x11, x1, x2       # x11 = 1
    sltu x12, x1, x2       # x12 = 1

    # Instruções de memória
    lui  x13, 0x10000      # x13 = 0x10000 << 12
    auipc x14, 0x10000     # x14 = PC + (0x10000 << 12)
    sw   x1, 0(x13)        # Mem[x13 + 0] = x1 = 10
    lw   x15, 0(x13)       # x15 = Mem[x13 + 0] = 10

    # Instruções de desvio condicional
    beq  x1, x2, .L1       # não toma o branch
    bne  x1, x2, .L2       # toma o branch

.L1:
    addi x16, x0, 1        # não executado

.L2:
    blt  x1, x2, .L3       # toma o branch
    bge  x1, x2, .L4       # não executado

.L3:
    addi x17, x0, 2        # x17 = 2

.L4:
    bltu x1, x2, .L5       # toma o branch
    bgeu x1, x2, .L6       # não executado

.L5:
    addi x18, x0, 3        # x18 = 3

.L6:
    # Instruções de salto e ligação
    jal  x19, .L7          # x19 = PC + 4

.L7:
    jalr x20, x19, 0       # x20 = PC + 4