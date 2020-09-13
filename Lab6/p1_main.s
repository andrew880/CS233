.data

# syscall constants
PRINT_INT = 1
PRINT_CHAR = 11

paints_array: .word 1, 3, 5, 7
costs_array:  .word 0, 2, 4, 6

.text
# main function ########################################################
#
#  this will test paint_cost
#

.globl main
main:
	# Test1 from lab6.cpp
	sub	$sp, $sp, 4
	sw	$ra, 0($sp)			# save $ra on stack
	

	li	$a0, 4				# test paint_cost
	la	$a1, paints_array
	la  $a2, costs_array
	jal	paint_cost

	move $a0, $v0 			# print result of paint_cost
	jal	print_int_and_space	# this should print 68


	# add new tests here


	lw	$ra, 0($sp)			# pop $ra from the stack
	add	$sp, $sp, 4
	jr	$ra
