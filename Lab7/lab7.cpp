/*
 * This is the C code for p1 and p2
 * To compile this:
 *      gcc lab7.cpp -o lab7_tests
 * You can then run the tests:
 *      ./lab7_tests
 */

#include <stdio.h>
#include <stdbool.h>

#define GRIDSIZE 4

typedef struct TreeNode {
    struct TreeNode* left;
    struct TreeNode* right;
    short value;
} TreeNode;

TreeNode g = {
    NULL,
    NULL,
    9999,
};

TreeNode f = {
    NULL,
    NULL,
    100,
};

TreeNode e = {
    &f,
    NULL,
    -11,
};

TreeNode d = {
    &e,
    NULL,
    0,
};

TreeNode c = {
    NULL,
    NULL,
    666,
};

TreeNode b = {
    &d,
    NULL,
    13,
};

TreeNode a = {
    &b,
    &c,
    7,
};

// part 1 p1.s
short count_odd_nodes(TreeNode* head) {
    // Base case
    if (head == NULL) {
        return 0;
    }
    // Recurse once for each child
	short count_left = count_odd_nodes(head->left);
    short count_right = count_odd_nodes(head->right);
    short count = count_left + count_right;
    // Determine if this current node is odd
    if (head->value%2 != 0) {
        count += 1;
    }
    return count;
}

// part2 common.s (can be taken from lab6)
void print_board(unsigned short* board) {
    for (int row = 0; row < GRIDSIZE; row++) {
        for (int col = 0; col < GRIDSIZE; col++) {
            printf("%2d ", board[row*GRIDSIZE+col]);
        }
        printf("\n");
    }
}

typedef struct Puzzle {
    unsigned short board[GRIDSIZE*GRIDSIZE];
    unsigned short constraints[(GRIDSIZE+2)*(GRIDSIZE+2)];
} Puzzle;

unsigned short heap[GRIDSIZE*GRIDSIZE*10000];

// p2 common.s
bool has_single_bit_set(short b)
{
    return b && !(b & (b-1));
}

// p1 p1.s
bool rule1(unsigned short* board) {
  bool changed = false;
  for (int y = 0 ; y < GRIDSIZE ; y++) {
    for (int x = 0 ; x < GRIDSIZE ; x++) {
      unsigned value = board[y*GRIDSIZE + x];
      if (has_single_bit_set(value)) {
        for (int k = 0 ; k < GRIDSIZE ; k++) {
          // eliminate from row
          if (k != x) {
            if (board[y*GRIDSIZE + k] & value) {
              board[y*GRIDSIZE + k] &= ~value;
              changed = true;
            }
          }
          // eliminate from column
          if (k != y) {
            if (board[k*GRIDSIZE + x] & value) {
              board[k*GRIDSIZE + x] &= ~value;
              changed = true;
            }
          }
        }
      }
    }
  }
  return changed;
}

// p2 p2_extra.s
bool rule2(unsigned short* board) {
  int ALL_VALUES = (1 << GRIDSIZE) - 1;
  bool changed = false;
  for (int i = 0 ; i < GRIDSIZE ; ++ i) {
    for (int j = 0 ; j < GRIDSIZE ; ++ j) {
      unsigned value = board[i*GRIDSIZE + j];
      if (has_single_bit_set(value)) {
        continue;
      }
      
      int jsum = 0, isum = 0;
      for (int k = 0 ; k < GRIDSIZE ; ++ k) {
        if (k != j) {
          jsum |= board[i*GRIDSIZE + k];        // summarize row
        }
        if (k != i) {
          isum |= board[k*GRIDSIZE + j];         // summarize column
        }
      }
      if (ALL_VALUES != jsum) {
        board[i*GRIDSIZE + j] = ALL_VALUES & ~jsum;
        changed = true;
        continue;
      } else if (ALL_VALUES != isum) {
        board[i*GRIDSIZE + j] = ALL_VALUES & ~isum;
        changed = true;
        continue;
      }
    }
  }
  return changed;
}

// p2 p2_extra.s
unsigned short* copy_board(unsigned short* old_board, unsigned short* new_board) {
    for (unsigned int i = 0; i < GRIDSIZE*GRIDSIZE; i++) {
        new_board[i] = old_board[i];
    }
}

// p2 p2_extra.s
unsigned short* increment_heap(unsigned short *old_board) {
    unsigned short *new_board = old_board + GRIDSIZE*GRIDSIZE * sizeof(unsigned short);
    copy_board(old_board, new_board);
    return new_board;
}

// p2 p2_extra.s
bool board_done(unsigned short *current_board, Puzzle* puzzle) {
    // Check if all columns and rows are unique
    int ALL_VALUES = (1 << GRIDSIZE) - 1;
    for (int i = 0 ; i < GRIDSIZE; ++ i) {
        short acc = 0;
        for (int j = 0 ; j < GRIDSIZE ; ++ j) {
            unsigned value = current_board[i*GRIDSIZE + j];
            if (!has_single_bit_set(value)) {
                continue;
            }
            acc = acc ^ value;
        }
        // check if all bits in rows are unique
        if (acc != ALL_VALUES) {
            // printf("Row %d unique failed %d - %d\n", i, acc, ALL_VALUES);
            return false;
        }
        acc = 0;
        for (int j = 0 ; j < GRIDSIZE ; ++ j) {
            unsigned value = current_board[j*GRIDSIZE + i];
            if (!has_single_bit_set(value)) {
                continue;
            }
            acc ^= value;
        }
        // check if all bits in cols are unique
        if (acc != ALL_VALUES) {
            return false;
        }
    }

    for (int i = 0 ; i < GRIDSIZE; ++ i) {
        short left_constraint = puzzle->constraints[(i+1)*(GRIDSIZE+2) + 0];
        int count = 0;
        int last = 0;
        for (int j = 0; j < GRIDSIZE; ++ j) {
            int current = current_board[i*GRIDSIZE + j];
            if (current > last) {
                count += 1;
                last = current;
            }
        }
        if (count != left_constraint) {
            return false;
        }

        short right_constraint = puzzle->constraints[(i+1)*(GRIDSIZE+2) + GRIDSIZE + 1];
        count = 0;
        last = 0;
        for (int j = GRIDSIZE-1; j >= 0; --j) {
            int current = current_board[i*GRIDSIZE + j];
            if (current > last) {
                count += 1;
                last = current;
            }
        }
        if (count != right_constraint) {
            return false;
        }

        short top_constraint = puzzle->constraints[i + 1];
        count = 0;
        last = 0;
        for (int j = 0; j < GRIDSIZE; ++ j) {
            int current = current_board[j*GRIDSIZE + i];
            if (current > last) {
                count += 1;
                last = current;
            }
        }
        if (count != top_constraint) {
            return false;
        }

        short bottom_constraint = puzzle->constraints[(GRIDSIZE+1)*(GRIDSIZE+2) + i + 1];
        count = 0;
        last = 0;
        for (int j = GRIDSIZE-1; j >= 0; --j) {
            int current = current_board[j*GRIDSIZE + i];
            if (current > last) {
                count += 1;
                last = current;
            }
        }
        if (count != bottom_constraint) {
            return false;
        }
    }

    return true;
}

// p1 p1.s
bool solve(unsigned short *current_board, unsigned row, unsigned col, Puzzle* puzzle) {
    if (row >= GRIDSIZE || col >= GRIDSIZE) {
        bool done = board_done(current_board, puzzle);
        if (done) {
            copy_board(current_board, puzzle->board);
        }

        return done;
    }
    current_board = increment_heap(current_board);

    bool changed;
    do {
        changed = rule1(current_board);
        changed |= rule2(current_board);
    } while (changed);

    short possibles = current_board[row*GRIDSIZE + col];
    for(char number = 0; number < GRIDSIZE; ++number) {
        // Remember & is a bitwise operator
        if ((1 << number) & possibles) {
            current_board[row*GRIDSIZE + col] = 1 << number;
            unsigned next_row = ((col == GRIDSIZE-1) ? row + 1 : row);
            if (solve(current_board, next_row, (col + 1) % GRIDSIZE, puzzle)) {
                return true;
            }
            current_board[row*GRIDSIZE + col] = possibles;
        }
    }
    return false;
}

// p1_main.s p2_main.s
int main() {
    //p1
    // TEST 1 - count_odd_nodes
    short oddA = count_odd_nodes(&a);
    printf("A: %d\n", oddA);
    // TEST 2 - count_odd_nodes
    short oddD = count_odd_nodes(&d);
    printf("D: %d\n", oddD);
    // TEST 3 - count_odd_nodes
    short oddG = count_odd_nodes(&g);
    printf("G: %d\n", oddG);

    // p2
    // TEST 4 - rule1
    unsigned short ALL_VALUES = (1 << GRIDSIZE) - 1;
    unsigned short board1[GRIDSIZE*GRIDSIZE] = {
        ALL_VALUES, ALL_VALUES, ALL_VALUES, ALL_VALUES,
        ALL_VALUES,          4, ALL_VALUES, ALL_VALUES,
        ALL_VALUES, ALL_VALUES, ALL_VALUES, ALL_VALUES,
        ALL_VALUES, ALL_VALUES, ALL_VALUES, ALL_VALUES,
    };
    bool changed = rule1(board1);
    // changed == true
    printf("%s\n", changed ? "T" : "F");
    print_board(board1);
    // Solution
    // 15 11 15 15  
    // 11  4 11 11  
    // 15 11 15 15  
    // 15 11 15 15

    // TEST 5 - rule1
    unsigned short board2[GRIDSIZE*GRIDSIZE] = {
                 8, ALL_VALUES, ALL_VALUES, ALL_VALUES,
        ALL_VALUES, ALL_VALUES, ALL_VALUES, ALL_VALUES,
        ALL_VALUES, ALL_VALUES, ALL_VALUES, ALL_VALUES,
        ALL_VALUES, ALL_VALUES, ALL_VALUES,          1,
    };
    changed = rule1(board2);
    // changed == true
    printf("%s\n", changed ? "T" : "F");
    print_board(board2);
    // Solution
    //  8  7  7  6  
    //  7 15 15 14
    //  7 15 15 14
    //  6 14 14  1

    // TEST 6 - solve
    Puzzle puzzle1 = {
        {
            ALL_VALUES, ALL_VALUES, ALL_VALUES, ALL_VALUES,
            ALL_VALUES, ALL_VALUES, ALL_VALUES, ALL_VALUES,
            ALL_VALUES, ALL_VALUES, ALL_VALUES, ALL_VALUES,
            ALL_VALUES, ALL_VALUES, ALL_VALUES, ALL_VALUES,
            // Solution
            // 1, 8, 2, 4,
            // 2, 1, 4, 8,
            // 4, 2, 8, 1,
            // 8, 4, 1, 2,
        },
        {
            0, 4, 1, 3, 2, 0,
            2, 0, 0, 0, 0, 2,
            3, 0, 0, 0, 0, 1,
            2, 0, 0, 0, 0, 2,
            1, 0, 0, 0, 0, 3,
            0, 1, 2, 2, 2, 0,
        }
    };
    unsigned short *board = (unsigned short*)&puzzle1.board;
    copy_board(board, heap);

    bool done = solve(heap, 0, 0, &puzzle1);
    // done must be true
    print_board(board);
    printf("\n");

    // TEST 6 - solve
    Puzzle puzzle2 = {
        {
            ALL_VALUES, ALL_VALUES, ALL_VALUES, ALL_VALUES,
            ALL_VALUES, ALL_VALUES, ALL_VALUES, ALL_VALUES,
            ALL_VALUES, ALL_VALUES, ALL_VALUES, ALL_VALUES,
            ALL_VALUES, ALL_VALUES, ALL_VALUES, ALL_VALUES,
            // Solution
            // 8  4  2  1
            // 4  1  8  2  
            // 1  2  4  8
            // 2  8  1  4
        },
        {
            0, 1, 2, 2, 3, 0,
            1, 0, 0, 0, 0, 4,
            2, 0, 0, 0, 0, 2,
            4, 0, 0, 0, 0, 1,
            2, 0, 0, 0, 0, 2,
            0, 3, 1, 3, 2, 0,
        }
    };
    board = (unsigned short*)&puzzle2.board;
    copy_board(board, heap);

    done = solve(heap, 0, 0, &puzzle2);
    // done must be true
    print_board(board);
    printf("\n");

    // Feel Free to add more tests here:
}