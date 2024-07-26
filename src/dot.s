.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:
    li t0, 1
    bge a2, t0, continue1
    li a0, 36
    j exit
continue1:
    bge a3, t0, continue2
    li a0, 37
    j exit
continue2:
    bge a4, t0, continue3
    li a0, 37
    j exit

continue3:
	# Prologue
    addi sp, sp, -12
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    
    li s0, 0 # counter
    li s1, 0 # product
    li s2, 0 # sum

loop_start:

    bge s0, a2, loop_end
    mul t0, s0, a3 
    mul t1, s0, a4
    slli t2, t0, 2
    slli t3, t1, 2
    add t2, t2, a0
    add t3, t3, a1
    lw t4, 0(t2)
    lw t5, 0(t3)
    mul s1, t4, t5
    add s2, s2, s1
    addi s0, s0, 1
    jal x0, loop_start

loop_end:
    mv a0, s2
	# Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    addi sp, sp, 12

	ret
