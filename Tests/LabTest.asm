lw x1, 0(x0)
lw x2, 4(x0)
lw x3, 8(x0)
or x4, x1, x2 
beq x4, x3, 4
add x3, x1, x2
add x5, x3, x2 
sw x5, 12(x0)
lw x6, 12(x0)
and x7, x6, x1
sub x8, x1, x2 