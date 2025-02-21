.text
    addi x1, x0, 10        # x1 = 10
    addi x2, x0, 20        # x2 = 20
    andi x3, x1, 3	   # x3 = 2
    ori  x4, x1, 3	   # x4 = 11
    xori x5, x1, 9 	   # x5 = 3
    add  x6, x1, x2        # x6 = 30
    sub  x7, x2, x1        # x7 = 10
    xor  x8, x1, x2        # x8 = 30
    or   x9, x1, x2        # x9 = 30
    and  x10, x1, x2       # x10 = 0
    sll  x11, x1, x2       # x11 = 10 << 20
    srl  x12, x2, x1       # x12 = 20 >> 10
    sra  x13, x2, x1       # x13 = 20 >> 10
    slli x14, x1, 1	   # x14 = 20
    srli x15, x1, 1	   # x15 = 5
    srai x16, x1, 1	   # x16 = 5
    slt  x17, x1, x2       # x17 = 1
    sltu x18, x1, x2       # x18 = 1
    slti x19, x1, -1	   # x19 = 0
    sltiu x20, x1, -1	   # x20 = 1
    lui  x21, 0x10000      # x21 = 0x10000 << 12
    auipc x22, 0x10000     # x22 = PC + (0x10000 << 12)
    sw   x1, 0(x21)        # Mem[x21 + 0] = x1 = 10
    sb   x2, 1(x21)	   # Mem[x21 + 1] = x1 = 10
    lw   x23, 0(x21)       # x23 = Mem[x23 + 0] = 5130
    lb   x24, 0(x21)	   # x24 = Mem[x24 + 0] = 10
    lbu  x25, 1(x21)	   # x25 = Mem[x25 + 0] = 20
    beq  x1, x2, .L1       # não toma o branch
    bne  x1, x2, .L2       # toma o branch
.L1: addi x26, x0, 1        # não executado
.L2: blt  x1, x2, .L3       # toma o branch
     addi x27, x0, 2	    # não executado
.L3: bge  x1, x2, .L4       # Não toma o branch
     addi x28, x0, 3        # x28 = 2
.L4: bgeu x1, x2, .L5       # não toma o branch
     bltu x1, x2, .L6       # toma o branch
.L5: addi x29, x0, 3        # não executado
.L6: jal  x30, .L7          # x30 = PC + 4
.L7: addi x1, x1, 1	    # x1++
     jalr x31, x30, 0       # x31 = PC + 4
