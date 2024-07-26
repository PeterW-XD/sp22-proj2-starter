.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
    li t0, 1
    blt a1, t0, invalid

	# Prologue
    addi sp, sp, -12
    sw sp, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    
    addi s0, x0, 1 # const 1
    addi s1, x0, 0 # counter

loop_start:
    slli t0, s1, 2
    add t0, t0, a0
    lw t1, 0(t0) # the max
    addi t3, x0, 0
    
loop_continue:
    addi s1, s1, 1
    bge s1, a1, loop_end
    slli t0, s1, 2
    add t0, t0, a0
    lw t2, 0(t0)
    bge t1, t2, loop_continue
    mv t1, t2
    mv t3, s1
    jal x0, loop_continue
   
loop_end:
    mv a0, t3
    
    lw sp, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    addi sp, sp, 12
	# Epilogue

	ret

invalid:
    li a0, 36
    j exit
