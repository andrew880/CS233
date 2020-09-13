.text

# int count_painted(int *wall, int width, int radius, int coord) {
# 	int row = (coord & 0xffff0000) >> 16;
# 	int col = coord & 0x0000ffff;
# 	int value = 0;
# 	for (int row_offset = -radius; row_offset <= radius; row_offset++) {
# 		int temp_row = row + row_offset;
# 		if (width <= temp_row || temp_row < 0) {
# 			continue;
# 		}
# 		for (int col_offset = -radius; col_offset <= radius; col_offset++) {
# 			int temp_col = col + col_offset;
# 			if (width <= temp_col || temp_col < 0) {
# 				continue;
# 			}
# 			value += wall[temp_row*width + temp_col];
# 		}
# 	}
# 	return value;
# }
#
# // a0: int *wall
# // a1: int width
# // a2: int radius
# // a3: int coord

.globl count_painted
count_painted:
	srl $t0, $a3, 16						#row
	sll $t1, $a3, 16						#col
	srl $t1, $t1, 16
	add $t2, $0, $0 						#value

	sub $t3, $0, $a2						#row_offset
	for_row:
		bgt $t3, $a2, row_out
		add $t4, $t0, $t3				#row_temp
		slt $t7, $t4, $a1
		slt $t8, $t4, $0
		slt $t7, $t8, $t7
		beq $0, $t7, add_row			#if continue

		sub $t5, $0, $a2					#col_offset
		for_col:
			bgt $t5, $a2, add_row
			add $t6, $t1, $t5			#col_temp
			slt $t7, $t6, $a1
			slt $t8, $t6, $0
			slt $t7, $t8, $t7
			beq $0, $t7, add_col			#if continue

			mul $t7, $t4, $a1
			add $t7, $t7, $t6
			mul $t7, $t7, 4
			add $t7, $t7, $a0
			lw $t7, 0($t7)
			add $t2, $t2, $t7				#add value

			add_col:								#col++
				addi $t5, $t5, 1
			j for_col

		add_row:									#row++
			addi $t3, $t3, 1
		j for_row
	row_out:
 	add $v0, $0, $t2
	jr	$ra

# int* get_heat_map(int *wall, int width, int radius) {
# 	int value = 0;
# 	for (int col = 0; col < width; col++) {
# 		for (int row = 0; row < width; row++) {
# 			int coord = (row << 16) | (col & 0x0000ffff);
# 			output_map[row*width + col] = count_painted(wall, width, radius, coord);
# 		}
# 	}
# 	return output_map;
# }
#
# // a0: int *wall
# // a1: int width
# // a2: int radius

.globl get_heat_map
get_heat_map:
	# Can access output_wall from p2.s
	sub		$sp, $sp, 16
	sw		$ra, 0($sp)		# save $ra on stack

	add $s0, $0, $a0
	add $s1, $0, $a1
	add $s2, $0, $a2

	add $t3, $0, $0						#col
	for_c:
		bge $t3, $a1, col_o
		add $t5, $0, $0					#row
		for_r:
			bge $t5, $a1, add_c

			sll $t0, $t5, 16
			sll $t1, $t3, 16
			srl $t1, $t1, 16
			or $t0, $t0, $t1				#coord
			mul $t1, $t3, $a1
			add $t1, $t1, $t5
			la $v0, output_wall
			mul $t1, $t1, 4
			add $t1, $t1, $v0				#map index
			move $a3, $t0

			sw $t3, 4($sp)
			sw $t5, 8($sp)
			sw $t1, 12($sp)

			jal count_painted

			add $a0, $0, $s0
			add $a1, $0, $s1
			add $a2, $0, $s2
			lw $t3, 4($sp)
			lw $t5, 8($sp)
			lw $t1, 12($sp)
			sw $v0, 0($t1)					#save output map

			add_r:								#col++
				addi $t5, $t5, 1
			j for_r

		add_c:									#row++
			addi $t3, $t3, 1
		j for_c
	col_o:
	lw $ra, 0($sp)
	add $sp, $sp, 16
	la $v0, output_wall				#output_map
	jr	$ra
