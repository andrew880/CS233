.text

# // Finds the dot product between two different arrays of size n
# // Ignore integer overflow for the multiplication
# int paint_cost(unsigned int n, unsigned int* paint, unsigned int* cost) {
# 	int total = 0;
# 	for (int i = 0; i < n; i++) {
# 		total += paint[i] * cost[i];
# 	}
# 	return total;
# }

.globl paint_cost
paint_cost:
	add $t0, $0, $0 #total = 0
	add $t1, $0, $0 # i = 0
	add $t6, $0, $a1 #paint
	add $t7, $0, $a2 #cost
for_start:
	bge $t1, $a0, end
	lw $t3, 0($a1) #paint
	lw $t4, 0($a2) #cost
	mul $t2, $t3, $t4 #paint*cost
	add $t0, $t0, $t2 # total mult
	addi $a1, $a1, 4
	addi $a2, $a2, 4
	addi $t1, $t1, 1
	j for_start
end:
	add $a1, $0, $t6
	add $a2, $0, $t7
	add $v0, $0, $t0
	jr	$ra
