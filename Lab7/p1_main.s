########################################################################
# BEWARE!
# DO NOT EDIT CONTENTS OF THIS FILE.
# THIS FILE WILL NOT BE GRADED
########################################################################
# typedef struct TreeNode {
#     struct TreeNode* left;
#     struct TreeNode* right;
#     short value;
# } TreeNode;
.data
    g_node: 
    .word     0      0
    .half 9999
    f_node: 
    .word     0      0
    .half 100
    e_node: 
    .word     f_node 0
    .half -11
    d_node: 
    .word     e_node 0
    .half 0
    c_node: 
    .word     0      0
    .half 666
    b_node: 
    .word     d_node 0
    .half 13
    a_node: 
    .word     b_node c_node
    .half 7
.text

# main function ########################################################
#
#  this is a function that will test dfs
#

.globl main
main:
    sub $sp, $sp, 4
    sw  $ra, 0($sp) # save $ra on stack

    # TEST 1
    la $a0, a_node
    jal count_odd_nodes
    move $a0, $v0
    jal print_int_and_space # Print 3

    # TEST 2
    la $a0, d_node
    jal count_odd_nodes
    move $a0, $v0
    jal print_int_and_space # Print 1

    # TEST 3
    la $a0, g_node
    jal count_odd_nodes
    move $a0, $v0
    jal print_int_and_space # Print 1

    # Feel free to add more tests

    lw  $ra, 0($sp)
    add $sp, $sp, 4
    jr  $ra


