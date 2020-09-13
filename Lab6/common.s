.data
# syscall constants
PRINT_INT = 1
PRINT_CHAR = 11

.text

########################################################################
# BEWARE!
# DO NOT EDIT CONTENTS OF THIS FILE.
# THIS FILE WILL NOT BE GRADED
########################################################################

# print int and space ##################################################
#
# argument $a0: number to print
.globl print_int_and_space
print_int_and_space:
	li	$v0, PRINT_INT	# load the syscall option for printing ints
	syscall			# print the number

	li   	$a0, ' '       	# print a black space
	li	$v0, PRINT_CHAR	# load the syscall option for printing chars
	syscall			# print the char
	
	jr	$ra		# return to the calling procedure

# print char ###########################################################
#
# argument $a0: char to print
.globl print_char
print_char:
	li	$v0, PRINT_CHAR	# load the syscall option for printing chars
	syscall			# print the char
	
	jr	$ra		# return to the calling procedure

# print board ##########################################################
#
# argument $a0: pointer to start of 2d tiles array
# argument $a1: width for 2d array
.globl print_wall
print_wall:
	sub		$sp, $sp, 20
	sw		$ra,  0($sp)		# save $ra on stack
	sw		$s0,  4($sp)		# save $s0 on stack
	sw		$s1,  8($sp)		# save $s1 on stack
	sw		$s2, 12($sp)		# save $s2 on stack
	sw		$s3, 16($sp)		# save $s3 on stack

	move	$s0, $a0
	move	$s1, $a1

	mul		$s2, $s1, $s1
	mul		$s2, $s2, 4
	li		$s3, 0
print_wall_loop:
	bge		$s3, $s2, print_wall_end
	add		$t0, $s0, $s3
	lw		$t0, 0($t0)

	move	$a0, $t0
	jal print_int_and_space

	li $t2, 4
	addi	$s3, $s3, 4
	div		$s3, $t2
	mflo	$t0	
	div		$t0, $s1
	mfhi	$t0

	bne		$t0, $0, print_wall_loop
	li		$a0, '\n'
	jal print_char
	j 		print_wall_loop
print_wall_end:
	lw		$ra,  0($sp)		# pop $ra from the stack
	lw		$s0,  4($sp)		# pop $s0 from the stack
	lw		$s1,  8($sp)		# pop $s1 from the stack
	lw		$s2, 12($sp)		# pop $s2 from the stack
	lw		$s3, 16($sp)		# pop $s3 from the stack
	add		$sp, $sp, 20
	jr		$ra