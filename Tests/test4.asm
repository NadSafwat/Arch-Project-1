addi t0, zero, 1 # x = 1
addi t1, zero, 0 # i = 0
addi t2, zero, 6 # y = 6

store:
	beq t0, t2, endStore # i == y?
	sw t0, 0(t1)	# mem[i] = x
    	addi t1, t1, 4	# i+=4
    	addi t0, t0, 1	# x++
    	beq zero, zero, store # loop back
    
endStore:

addi t0, zero, 0 # i = 0
addi t1, zero, 0 # *i -> pointer to mem
addi t2, zero, 16 # *(4-i) -> pointer to mem
addi t3, zero, 3 # x = 3

swap:
	beq t0, t3, endSwap # i == x?
	
	lw t4, 0(t1) # temp1 = mem[i]
	lw t5, 0(t2) # temp2 = mem[4-i]
	
	sw t4, 0(t2) # mem[4-i] = temp1
	sw t5, 0(t1) # mem[i] = temp2
	
	addi t0, t0, 1 # i++
	addi t1, t1, 4 # *(i+1) -> move pointer up
	addi t2, t2, -4 # *(4-i-1) -> move pointer down
	
	beq zero, zero, swap # loop back

endSwap: