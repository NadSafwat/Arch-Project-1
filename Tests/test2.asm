lbu x1, 0(x0) #x1 = 24
lh x2, 4(x0) #x2 = 2
lb x3, 8(x0) #x3 = -126
lhu x4, 12(x0) #x4 = 3
sll x5, x1, x2 #x5 = 96
slt x6, x3, x1 #x6 = 1
sltu x7, x3, x1 #x7 = 0
xor x8, x6, x5 #x8 = 97
srl x9, x3, x2 #x9 = 1073741792
sra x10,x3, x2 #x10 = -32