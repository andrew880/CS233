.data

test_wall1:
.word	1  1  1  1  1
.word	1 -1 -1 -1  1
.word	1 -1 -1 -1  1
.word	1  1  1  1  1
.word	1  1  1  1  1

test_wall2:
.word	1 1 1 1 1 1 1
.word	1 2 2 2 2 2 1
.word	1 2 3 3 3 2 1
.word	1 2 3 4 3 2 1
.word	1 2 3 3 3 2 1
.word	1 2 2 2 2 2 1
.word	1 1 1 1 1 1 1

.globl output_wall
output_wall: .word 0:10000

.text

# main function ########################################################
#
#  this is a function that will test count_painted and get_heat_map
#

.globl main
main:
	sub		$sp, $sp, 4
	sw		$ra, 0($sp)		# save $ra on stack

	# Test2 from lab6.cpp
	la		$a0, test_wall1		# test count_painted
	li		$a1, 5
	li		$a2, 1
	li		$a3, 0x00030002
	jal	count_painted

	move	$a0, $v0
	jal	print_int_and_space	# this should print 3

	# print new line
	li		$a0, '\n'
	jal print_char

	# Test3 from lab6.cpp
	la		$a0, test_wall2		# test get_heat_map
	li		$a1, 7
	li		$a2, 1
	jal	get_heat_map

	move	$a0, $v0
	li		$a1, 7
	jal		print_wall	# this should print:
	# 5  8  9  9  9  8  5
	# 8 14 17 18 17 14  8
	# 9 17 23 25 23 17  9
	# 9 18 25 28 25 18  9
	# 9 17 23 25 23 17  9
	# 8 14 17 18 17 14  8
	# 5  8  9  9  9  8  5

	lw	$ra, 0($sp) 		# pop $ra from the stack
	add	$sp, $sp, 4
	jr	$ra
