lui x1, 2 #x1 = 8192
auipc x2, 5 #x2 = 20484
jal x3, 8 # x3 = 12 ; PC = 16
ebreak
bne x1, x2, 8 #PC = 24
ecall
addi x4, x0, -56   #x4 = -56
blt x1, x2, 8 #PC = 36
ecall
sb x2, 0(x0)  #mem[0] = 4
bge x2, x1, 8 #PC = 48
ecall
bltu x1, x4, 8
ecall
bgeu x4, x2, 8
ecall
sh x4, 1(x0)
ecall
fence
fence.i
jalr x0, x3, 0