.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:
	# Error checks
    ebreak
    li t0, 1
    blt a1, t0, invalid
    blt a2, t0, invalid
    blt a4, t0, invalid
    blt a5, t0, invalid
    bne a2, a4, invalid

	# Prologue
    addi sp, sp, -24
    sw sp, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp) # start pointer of mat a
    sw s4, 20(sp) # mat b

    li s0, 0 # row count
    li s1, 0 # clm count
    li s2, 0 # new entry addr
    
outer_loop_start:
    bge s0, a1, outer_loop_end
    mul s3, s0, a2
    slli s3, s3, 2
    add s3, s3, a0

inner_loop_start:
    bge s1, a5, inner_loop_end
    mul s2, s0, a5
    add s2, s2, s1
    slli s2, s2, 2
    add s2, s2, a6 # dest addr
    add s4, x0, s1
    slli s4, s4, 2
    add s4, s4, a3
    
    addi sp, sp, -32
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw a3, 12(sp)
    sw a4, 16(sp)
    sw a5, 20(sp)
    sw a6, 24(sp)
    sw ra, 28(sp)
    
    mv a0, s3
    mv a1, s4
    addi a3, x0, 1
    mv a4, a5
    jal ra, dot
    sw a0, 0(s2) #
    
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw a3, 12(sp)
    lw a4, 16(sp)
    lw a5, 20(sp)
    lw a6, 24(sp)
    lw ra, 28(sp)
    addi sp, sp, 32
    
    addi s1, s1, 1
    jal x0, inner_loop_start

inner_loop_end:
    addi s0, s0, 1
    addi s1, x0, 0
    jal x0, outer_loop_start

outer_loop_end:
   
    lw sp, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    addi sp, sp, 24
	# Epilogue

	ret

invalid:
    li a0, 38
    j exit
