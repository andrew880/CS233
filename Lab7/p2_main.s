########################################################################
# BEWARE!
# DO NOT EDIT CONTENTS OF THIS FILE.
# THIS FILE WILL NOT BE GRADED
########################################################################
.data
ALL_VALUES = 0xf # Hardcoded constant for binary 1111

board1:
.half ALL_VALUES ALL_VALUES ALL_VALUES ALL_VALUES
.half ALL_VALUES          4 ALL_VALUES ALL_VALUES
.half ALL_VALUES ALL_VALUES ALL_VALUES ALL_VALUES
.half ALL_VALUES ALL_VALUES ALL_VALUES ALL_VALUES

board2:
.half          8 ALL_VALUES ALL_VALUES ALL_VALUES
.half ALL_VALUES ALL_VALUES ALL_VALUES ALL_VALUES
.half ALL_VALUES ALL_VALUES ALL_VALUES ALL_VALUES
.half ALL_VALUES ALL_VALUES ALL_VALUES          1

puzzle1:
.half ALL_VALUES ALL_VALUES ALL_VALUES ALL_VALUES
.half ALL_VALUES ALL_VALUES ALL_VALUES ALL_VALUES
.half ALL_VALUES ALL_VALUES ALL_VALUES ALL_VALUES
.half ALL_VALUES ALL_VALUES ALL_VALUES ALL_VALUES
.half 0, 4, 1, 3, 2, 0,
.half 2, 0, 0, 0, 0, 2,
.half 3, 0, 0, 0, 0, 1,
.half 2, 0, 0, 0, 0, 2,
.half 1, 0, 0, 0, 0, 3,
.half 0, 1, 2, 2, 2, 0,

puzzle2:
.half ALL_VALUES ALL_VALUES ALL_VALUES ALL_VALUES
.half ALL_VALUES ALL_VALUES ALL_VALUES ALL_VALUES
.half ALL_VALUES ALL_VALUES ALL_VALUES ALL_VALUES
.half ALL_VALUES ALL_VALUES ALL_VALUES ALL_VALUES
.half 0, 1, 2, 2, 3, 0,
.half 1, 0, 0, 0, 0, 4,
.half 2, 0, 0, 0, 0, 2,
.half 4, 0, 0, 0, 0, 1,
.half 2, 0, 0, 0, 0, 2,
.half 0, 3, 1, 3, 2, 0,

.globl heap
heap:
.half 0:1000

.text
# main function ########################################################
.globl main
main:
    sub $sp, $sp, 4
    sw  $ra, 0($sp)   # save $ra on stack

    # TEST 4
    la  $a0, board1
    jal rule1
    move $a0, $v0
    jal print_bool_and_newline # Will print T
    la  $a0, board1
    li  $a1, 4
    jal print_board
    # Print Board
    # 15 11 15 15
    # 11  4 11 11
    # 15 11 15 15
    # 15 11 15 15

    # TEST 5
    la  $a0, board2
    jal rule1
    move $a0, $v0
    jal print_bool_and_newline # Will print T
    la  $a0, board2
    li  $a1, 4
    jal print_board
    # Print Board
    #  8  7  7  6
    #  7 15 15 14
    #  7 15 15 14
    #  6 14 14  1

#    add $t0, $0, GRIDSIZE
#    add $a0, $0, 5
#    div $a0, $t0							#mod (col + 1) % GRIDSIZE
#    mfhi $a0
#    jal	print_int_and_space

    # Test 6
    # Copy puzzle to heap
    la  $a0, puzzle1
    la  $a1, heap
    jal copy_board    # Copy board to heap

    la  $a0, heap     # current_board = heap
    li  $a1, 0        # row = 0
    li  $a2, 0        # col = 0
    la  $a3, puzzle1  # puzzle = puzzle1
    jal solve
    move $a0, $v0
    jal print_bool_and_newline # Will print T

    la $a0, puzzle1
    li $a1, 4
    jal print_board
    # Print Board
    # 1, 8, 2, 4,
    # 2, 1, 4, 8,
    # 4, 2, 8, 1,
    # 8, 4, 1, 2,


    # Test 7
    # Copy puzzle to heap
    la  $a0, puzzle2
    la  $a1, heap
    jal copy_board    # Copy board to heap

    la  $a0, heap     # current_board = heap
    li  $a1, 0        # row = 0
    li  $a2, 0        # col = 0
    la  $a3, puzzle2  # puzzle = puzzle1
    jal solve
    move $a0, $v0
    jal print_bool_and_newline # Will print T

    la $a0, puzzle2
    li $a1, 4
    jal print_board
    # Print Board
    # 8  4  2  1
    # 4  1  8  2
    # 1  2  4  8
    # 2  8  1  4


    lw  $ra, 0($sp)
    add $sp, $sp, 4
    jr  $ra
