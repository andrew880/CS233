.text

# bool rule1(unsigned short* board) {
#   bool changed = false;
#   for (int y = 0 ; y < GRIDSIZE ; y++) {
#     for (int x = 0 ; x < GRIDSIZE ; x++) {
#       unsigned value = board[y*GRIDSIZE + x];
#       if (has_single_bit_set(value)) {
#         for (int k = 0 ; k < GRIDSIZE ; k++) {
#           // eliminate from row
#           if (k != x) {
#             if (board[y*GRIDSIZE + k] & value) {
#               board[y*GRIDSIZE + k] &= ~value;
#               changed = true;
#             }
#           }
#           // eliminate from column
#           if (k != y) {
#             if (board[k*GRIDSIZE + x] & value) {
#               board[k*GRIDSIZE + x] &= ~value;
#               changed = true;
#             }
#           }
#         }
#       }
#     }
#   }
#   return changed;
# }
#a0: board

.globl rule1
rule1:
	sub $sp, $sp, 32
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $s0, 24($sp)
	sw $s5, 28($sp)

	add $s5, $0, $0										#s5 = changed
	add $s0, $0, $a0									#s0 = board
	add $s1, $0, $0 											# s1: y=0
	for_y:
		bge $s1, GRIDSIZE, end_rule1							#cond y break to end

		add $s2, $0, $0 										# s2: x=0
		for_x:
			bge $s2, GRIDSIZE, add_y					#cond x break to add_y
			mul $s4, $s1, GRIDSIZE				# GRIDSIZE * s1 (y)
			add $s4, $s4, $s2							# s4 + s2(x)
			mul $s4, $s4, 2
			add $s4, $s4, $s0							#&board[index]
			lh $s4, 0($s4)								#s4: value

			add $a0, $0, $s4
			jal has_single_bit_set
			beq $v0, $0, add_x 						#if has_single_bit_set value

			add $a0, $0, $s4							#set a0 to s4 (value)
			jal has_single_bit_set

			add $s3, $0, $0 									# s3: k=0
			for_k:
				bge $s3, GRIDSIZE, add_x				#cond k break to add_x

				beq $s3, $s2, contkx				#if k != x
					mul $t4, $s1, GRIDSIZE		# y * GRIDSIZE
					add $t4, $t4, $s3					# t4 + s3(k)
					mul $t4, $t4, 2						#index
					add $t4, $t4, $s0						#&board[index]
					lh $t3, 0($t4)							#board[index]
					and $t2, $t3, $s4
					beq $0, $t2, contkx				#if board & value
						nor $t2, $0, $s4
						and $t2, $t2, $t3
						sh $t2, 0($t4)						#board[index] &= ~value
						add $s5, $0, 1
					contkx:
				beq $s3, $s1, contky				#if k != y
					mul $t4, $s3, GRIDSIZE		#k * GRIDSIZE
					add $t4, $t4, $s2					#t4 + s2(x)
					mul $t4, $t4, 2						#index
					add $t4, $t4, $s0						#t4 = &board[index]
					lh $t3, 0($t4)							#t3 = board[index]
					and $t2, $t3, $s4
					beq $0, $t2, contky				#if board & value
						nor $t2, $0, $s4
						and $t2, $t2, $t3
						sh $t2, 0($t4)						#board[index] &= ~value
						add $s5, $0, 1
					contky:

			add_k:
				add $s3, $s3, 1
				j for_k
		add_x:
			add $s2, $s2, 1
			j for_x
	add_y:
		add $s1, $s1, 1
		j for_y

	end_rule1:
	add $v0, $0, $s5
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	lw $s0, 24($sp)
	lw $s5, 28($sp)
	add $sp, $sp, 32
	jr	$ra



# bool solve(unsigned short *current_board, unsigned row, unsigned col, Puzzle* puzzle) {
#     if (row >= GRIDSIZE || col >= GRIDSIZE) {
#         bool done = board_done(current_board, puzzle);
#         if (done) {
#             copy_board(current_board, puzzle->board);
#         }

#         return done;
#     }
#     current_board = increment_heap(current_board);

#     bool changed;
#     do {
#         changed = rule1(current_board);
#         changed |= rule2(current_board);
#     } while (changed);

#     short possibles = current_board[row*GRIDSIZE + col];
#     for(char number = 0; number < GRIDSIZE; ++number) {
#         // Remember & is a bitwise operator
#         if ((1 << number) & possibles) {
#             current_board[row*GRIDSIZE + col] = 1 << number;
#             unsigned next_row = ((col == GRIDSIZE-1) ? row + 1 : row);
#             if (solve(current_board, next_row, (col + 1) % GRIDSIZE, puzzle)) {
#                 return true;
#             }
#             current_board[row*GRIDSIZE + col] = possibles;
#         }
#     }
#     return false;
# }

.globl solve
solve:
	sub $sp, $sp, 36
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $s5, 24($sp)
	sw $s6, 28($sp)
	sw $s7, 32($sp)

	add $s0, $0, $a0
	add $s1, $0, $a1
	add $s2, $0, $a2
	add $s3, $0, $a3									#store input

	slt $t0, $s1, GRIDSIZE
	slt $t1, $s2, GRIDSIZE
	and $t0, $t0, $t1									# !a & !b
	bne $t0, $0, cont1								#if row >= GRIDSIZE || col >= GRIDSIZE
		add $a0, $0, $s0
		add $a1, $0, $s3				#set input
		jal board_done
		add $s4, $0, $v0			#store done in s4
		beq $v0, $0, contdone							#if done
			add $a0, $0, $s0
			add $a1, $0, $s3				#set input #puzzle->board
			jal copy_board
		contdone:
			add $v0, $s4, $0			#set return to done
			j end_solve
	cont1:
	add $a0, $0, $s0					#set input	increment heap
	jal increment_heap
	add $s0, $0, $v0						# s0: update current_board with increment_heap

	add $s4, $0, $0							# s4: changed
	while:																			#while
		add $a0, $0, $s0				#set input
		jal rule1
		add $s4, $0, $v0
		add $a0, $0, $s0				#set input
		jal rule2
		or $s4, $s4, $v0
		bne $s4, 0, while

	mul $s6, $s1, GRIDSIZE
	add $s6, $s6, $s2
	mul $s6, $s6, 2							# s6: index
	add $s6, $s6, $s0						# s6: &current_board[index]
	lh $s6, 0($s6)								#	s6: possibles

	add $s5, $0, $0							# s5: number
	for_num:																				#for
		bge $s5, GRIDSIZE, near_end
		add $t1, $0, 1								# t1 = 1
		sll $t1, $t1, $s5							# t1 << number
		and $t1, $t1, $s6							# 1 << number & possibles
		beq $t1, $0, add_num				# if ((1 << number) & possibles)
			mul $s7, $s1, GRIDSIZE
			add $s7, $s7, $s2
			mul $s7, $s7, 2
			add $s7, $s7, $s0				# s7: index = 2*(row * GRIDSIZE + col) + s0 (board)
			add $t1, $0, 1								# t1 = 1
			sll $t1, $t1, $s5							# t1 << number
			sh $t1, 0($s7)					# store board[index] = 1<< number

			add $t0, $0, GRIDSIZE
			sub $t0, $t0, 1
			add $a1, $0, $s1				# a1: next_row = row
			bne $s2, $t0, cont_next_row
			add $a1, $a1, 1					# a1++
			cont_next_row:					#assign next_row

			add $a0, $0, $s0
			add $a2, $s2, 1
			add $t0, $0, GRIDSIZE
			rem $a2, $a2, $t0							#mod (col + 1) % GRIDSIZE
			add $a3, $0, $s3			#set input
			jal solve
			add $t1, $0, $v0
			add $v0, $0, 1
			bne $t1, $0, end_solve					# if return TRUE

			add $v0, $0, $0
			sh $s6, 0($s7)
		add_num:
			add $s5, $s5, 1
			j for_num
		near_end:
			add $v0, $0, $0
	end_solve:
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	lw $s5, 24($sp)
	lw $s6, 28($sp)
	lw $s7, 32($sp)
	add $sp, $sp, 36
	jr $ra
