.text

# short count_odd_nodes(TreeNode* head) {
#     // Base case
#     if (head == NULL) {
#         return 0;
#     }
#     // Recurse once for each child
# 	short count_left = count_odd_nodes(head->left);
#     short count_right = count_odd_nodes(head->right);
#     short count = count_left + count_right;
#     // Determine if this current node is odd
#     if (head->value%2 != 0) {
#         count += 1;
#     }
#     return count;
# }

.globl count_odd_nodes
count_odd_nodes:
	li $v0, 0
	bne $a0, $0, cont
	jr $ra

	cont:
	sub $sp, $sp, 16 #alocate sp
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	move $s0, $a0

	lw $a0, 0($s0) #a0 -> left
	jal count_odd_nodes
	add $s1, $0, $v0 #s1 : count_left

	lw $a0, 4($s0) #a0 -> right
	jal count_odd_nodes
	add $s2, $0, $v0 #s2 : count_right

	add $t2, $s1, $s2 # t2 : count = left + right

	lh $t4, 8($s0) # t4 -> value
	and $t4, $t4, 1 # t4 % 2

	add $v0, $0, $t2 #v0 = count
	beq $t4, $0, end
	add $v0, $v0, 1

	end:
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	add $sp, $sp, 16 # dealocate sp
	jr $ra
