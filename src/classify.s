.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:
	# Read pretrained m0
ebreak
    li t0, 5
    bne a0, t0, cl_err
    
    addi sp, sp, -24
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    
    addi sp, sp, -24 # allocate space for pointers
    
    addi sp, sp, -16 
    sw ra, 0(sp)
    sw a0, 4(sp)
    sw a1, 8(sp)
    sw a2, 12(sp)

    lw a0, 4(a1)  # file path string
    addi a1, sp, 16 # the bottom of stack
    addi a2, sp, 20
    jal read_matrix
    mv s0, a0 # pointer to the matrix: m0

    lw ra, 0(sp)
    lw a0, 4(sp)
    lw a1, 8(sp)
    lw a2, 12(sp)
    addi sp, sp, 16
ebreak
	# Read pretrained m1
    addi sp, sp, -16 
    sw ra, 0(sp)
    sw a0, 4(sp)
    sw a1, 8(sp)
    sw a2, 12(sp)
    
    lw a0, 8(a1)
    addi a1, sp, 24
    addi a2, sp, 28
    jal read_matrix
    mv s1, a0 # pointer to the matrix: m1
    
    lw ra, 0(sp)
    lw a0, 4(sp)
    lw a1, 8(sp)
    lw a2, 12(sp)
    addi sp, sp, 16

	# Read input matrix
    addi sp, sp, -16 
    sw ra, 0(sp)
    sw a0, 4(sp)
    sw a1, 8(sp)
    sw a2, 12(sp)
    
    lw a0, 12(a1)
    addi a1, sp, 32
    addi a2, sp, 36
    jal read_matrix
    mv s2, a0 # pointer to the matrix input 
    
    lw ra, 0(sp)
    lw a0, 4(sp)
    lw a1, 8(sp)
    lw a2, 12(sp)
    addi sp, sp, 16
##
	# Compute h = matmul(m0, input)
    addi sp, sp, -16 
    sw ra, 0(sp)
    sw a0, 4(sp)
    sw a1, 8(sp)
    sw a2, 12(sp)
    
    lw t0, 16(sp) # row
    lw t1, 36(sp) # clm
    mul a0, t0, t1
    slli a0, a0, 2
    jal malloc
    beq a0, x0, ma_err
    mv s3, a0 # pointer to h
    
    lw ra, 0(sp)
    lw a0, 4(sp)
    lw a1, 8(sp)
    lw a2, 12(sp)
    addi sp, sp, 16
    
    addi sp, sp, -16 
    sw ra, 0(sp)
    sw a0, 4(sp)
    sw a1, 8(sp)
    sw a2, 12(sp)
    
    mv a0, s0
    lw a1, 16(sp)
    lw a2, 20(sp)
    mv a3, s2
    lw a4, 32(sp)
    lw a5, 36(sp)
    mv a6, s3
    jal matmul
    
    lw ra, 0(sp)
    lw a0, 4(sp)
    lw a1, 8(sp)
    lw a2, 12(sp)
    addi sp, sp, 16

	# Compute h = relu(h)
    addi sp, sp, -16 
    sw ra, 0(sp)
    sw a0, 4(sp)
    sw a1, 8(sp)
    sw a2, 12(sp)
    
    mv a0, s3
    lw t0, 16(sp) # row
    lw t1, 36(sp) # clm
    mul a1, t0, t1
    jal relu
    
    lw ra, 0(sp)
    lw a0, 4(sp)
    lw a1, 8(sp)
    lw a2, 12(sp)
    addi sp, sp, 16

	# Compute o = matmul(m1, h)
    addi sp, sp, -16 
    sw ra, 0(sp)
    sw a0, 4(sp)
    sw a1, 8(sp)
    sw a2, 12(sp)
    
    lw t0, 24(sp) # row
    lw t1, 36(sp) # clm
    mul a0, t0, t1
    slli a0, a0, 2
    jal malloc
    beq a0, x0, ma_err
    mv s4, a0 # pointer to o
    
    lw ra, 0(sp)
    lw a0, 4(sp)
    lw a1, 8(sp)
    lw a2, 12(sp)
    addi sp, sp, 16

    addi sp, sp, -16 
    sw ra, 0(sp)
    sw a0, 4(sp)
    sw a1, 8(sp)
    sw a2, 12(sp)
    
    mv a0, s1
    lw a1, 24(sp)
    lw a2, 28(sp)
    mv a3, s3
    lw a4, 16(sp)
    lw a5, 36(sp)
    mv a6, s4
    jal matmul
    
    lw ra, 0(sp)
    lw a0, 4(sp)
    lw a1, 8(sp)
    lw a2, 12(sp)
    addi sp, sp, 16   
ebreak
	# Write output matrix o
    addi sp, sp, -16 
    sw ra, 0(sp)
    sw a0, 4(sp)
    sw a1, 8(sp)
    sw a2, 12(sp)
    
    lw a0, 16(a1)
    mv a1, s4
    lw a2, 24(sp)
    lw a3, 36(sp)
    jal write_matrix
    
    lw ra, 0(sp)
    lw a0, 4(sp)
    lw a1, 8(sp)
    lw a2, 12(sp)
    addi sp, sp, 16  

	# Compute and return argmax(o)
    addi sp, sp, -16 
    sw ra, 0(sp)
    sw a0, 4(sp)
    sw a1, 8(sp)
    sw a2, 12(sp)

    mv a0, s4
    lw t0, 24(sp)
    lw t1, 36(sp)
    mul a1, t0, t1
    jal argmax
    mv s5, a0 # the index of the largest element

    lw ra, 0(sp)
    lw a0, 4(sp)
    lw a1, 8(sp)
    lw a2, 12(sp)
    addi sp, sp, 16  

# If enabled, print argmax(o) and newline
    bne a2, x0, nxt
    addi sp, sp, -16 
    sw ra, 0(sp)
    sw a0, 4(sp)
    sw a1, 8(sp)
    sw a2, 12(sp)
    
    mv a0, s5
    jal print_int
    li a0, '\n'
    jal print_char
    
    lw ra, 0(sp)
    lw a0, 4(sp)
    lw a1, 8(sp)
    lw a2, 12(sp)
    addi sp, sp, 16  
nxt:
# free heap memory
    addi sp, sp, -16 
    sw ra, 0(sp)
    sw a0, 4(sp)
    sw a1, 8(sp)
    sw a2, 12(sp)

    mv a0, s3
    jal free
    mv a0, s4
    jal free
    
    lw ra, 0(sp)
    lw a0, 4(sp)
    lw a1, 8(sp)
    lw a2, 12(sp)
    addi sp, sp, 16  
    
    mv a0, s5
    
    addi sp, sp, 24
    
    # epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    addi sp, sp, 24
ebreak
	ret

ma_err:
    li a0, 26
    j exit

cl_err:
    li a0, 31
    j exit