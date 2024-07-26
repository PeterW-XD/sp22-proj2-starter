.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:
	# Prologue

    addi sp, sp, -20
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)

    addi sp, sp, -16
    sw ra, 0(sp)
    sw a0, 4(sp)
    sw a1, 8(sp)
    sw a2, 12(sp)
    
    li a1, 0
    jal fopen
    li t0, -1
    beq a0, t0, fo_err
    mv s1, a0 # save file descriptor
    
    lw ra, 0(sp)
    lw a0, 4(sp)
    lw a1, 8(sp)
    lw a2, 12(sp)
    addi sp, sp, 16
    
    addi sp, sp, -8
    addi sp, sp, -16
    sw ra, 0(sp)
    sw a0, 4(sp)
    sw a1, 8(sp)
    sw a2, 12(sp)

    mv a0, s1
    addi a1, sp, 16 # buffer 
    li a2, 8  # the number of bytes
    jal fread
    li t0, 8
    bne a0, t0, fr_err
    
    lw ra, 0(sp)
    lw a0, 4(sp)
    lw a1, 8(sp)
    lw a2, 12(sp)
    addi sp, sp, 16
    lw s2, 0(sp) # row num
    lw s3, 4(sp) # clm num
    sw s2, 0(a1)
    sw s3, 0(a2)
    addi sp, sp, 8
    
    addi sp, sp, -16
    sw ra, 0(sp)
    sw a0, 4(sp)
    sw a1, 8(sp)
    sw a2, 12(sp)
    
    mul a0, s2, s3 # number of entries
    slli a0, a0, 2
    jal malloc
    beq a0, x0, ma_err
    mv s4, a0 # the pointer to heap mem
    
    lw ra, 0(sp)
    lw a0, 4(sp)
    lw a1, 8(sp)
    lw a2, 12(sp)
    addi sp, sp, 16
    
# fread
    addi sp, sp, -16
    sw ra, 0(sp)
    sw a0, 4(sp)
    sw a1, 8(sp)
    sw a2, 12(sp)

    mul s0, s2, s3
    slli s0, s0, 2 # s0 positive of num of elements in .bin
    xori t1, s0, -1
    addi t1, t1, 1
    add sp, sp, t1

    mv a0, s1
    mv a1, sp
    mv a2, s0

    jal fread
    bne a0, s0, fr_err
    
    li t1, 0 # counter
loop:
    slli t2, t1, 2 # offset for buffer
    beq t2, s0, loop_end
    add t3, sp, t2 # (sp)
    add t4, s4, t2 # (s4)
    lw t5, 0(t3)
    sw t5, 0(t4)
    addi t1, t1, 1
    j loop
    
loop_end:
    add sp, sp, s0

    lw ra, 0(sp)
    lw a0, 4(sp)
    lw a1, 8(sp)
    lw a2, 12(sp)
    addi sp, sp, 16

# close file
    addi sp, sp, -16
    sw ra, 0(sp)
    sw a0, 4(sp)
    sw a1, 8(sp)
    sw a2, 12(sp)
    
    mv a0, s1
    jal fclose
    li t0, -1
    beq a0, t0, fc_err
    
    lw ra, 0(sp)
    lw a0, 4(sp)
    lw a1, 8(sp)
    lw a2, 12(sp)
    addi sp, sp, 16
    
    mv a0, s4
	# Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    addi sp, sp, 20

	ret
    
fo_err:
    li a0, 27
    j exit
    
fr_err:
    li a0, 29
    j exit
    
ma_err:
    li a0, 26
    j exit

fc_err:
    li a0, 28
    j exit