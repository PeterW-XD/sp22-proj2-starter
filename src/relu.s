.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:
    li t0, 1
    blt a1, t0, exception
	# Prologue
    addi sp, sp, -12
    sw sp, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    addi s0, x0, 1
    add s1, x0, x0 # counter

loop_start:
    bge s1, a1, loop_end
    slli t0, s1, 2
    add t0, t0, a0
    lw t1, 0(t0)
    bge t1, x0, loop_continue
    sw x0, 0(t0)

loop_continue:
    addi s1, s1, 1
    jal x0, loop_start    

loop_end:
    lw sp, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    addi sp, sp, 12
	# Epilogue


	ret
exception:
    li a0, 36
    j exit
