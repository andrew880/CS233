#include <stdio.h>

/*
 * This file is a test bench to compare
 * the results of your mips code.
 * You can compile this file by running:
 *    gcc lab6.cpp -o cpp_tests
 * And then run those tests with:
 *    ./cpp_tests
 */

#define MAX_WIDTH 100
int output_map[MAX_WIDTH*MAX_WIDTH];

// p1.s
int paint_cost(unsigned int n, unsigned int* paint, unsigned int* cost) {
  int total = 0;
  for (int i = 0; i < n; i++) {
    total += paint[i] * cost[i];
  }
  return total; 
}

// p2.s
int count_painted(int *wall, int width, int radius, int coord) {
  int row = (coord & 0xffff0000) >> 16;
  int col = coord & 0x0000ffff;
  int value = 0;
  for (int row_offset = -radius; row_offset <= radius; row_offset++) {
    int temp_row = row + row_offset;
    if (width <= temp_row || temp_row < 0) {
      continue;
    }
    for (int col_offset = -radius; col_offset <= radius; col_offset++) {
      int temp_col = col + col_offset;
      if (width <= temp_col || temp_col < 0) {
        continue;
      }
      value += wall[temp_row*width + temp_col];
    }
  }
  return value;
}

// p2.s
int* get_heat_map(int *wall, int width, int radius) {
  int value = 0;
  for (int col = 0; col < width; col++) {
    for (int row = 0; row < width; row++) {
      int coord = (row << 16) | (col & 0x0000ffff);
      output_map[row*width + col] = count_painted(wall, width, radius, coord);
    }
  }
  return output_map;
}

// helper function
// prints out a 2d representation of the wall to the console
void print_wall(int* tiles, int width) {
  for (int row = 0; row < width; row++) {
    for (int col = 0; col < width; col++) {
      printf("%2d ",tiles[row*width+col]);
    }
    printf("\n");
  }
}

// The following function tests count_painted
void test1() {
  printf("Test1:\n");
  // the ammount of each paint we have
  unsigned int paints[4] = {1, 3, 5, 7};
  // the cost per gallon of that paint
  unsigned int costs[4] = {0, 2, 4, 6};
  int price = paint_cost(4, paints, costs);
  printf("It costs us %d money units for all the paint\n", price);
}

// we default test_wall1
int test_wall1[5*5] = {
  1,  1,  1,  1,  1,
  1, -1, -1, -1,  1,
  1, -1, -1, -1,  1,
  1,  1,  1,  1,  1,
  1,  1,  1,  1,  1
};

int test_wall2[7*7] = {
  1, 1, 1, 1, 1, 1, 1,
  1, 2, 2, 2, 2, 2, 1,
  1, 2, 3, 3, 3, 2, 1,
  1, 2, 3, 4, 3, 2, 1,
  1, 2, 3, 3, 3, 2, 1,
  1, 2, 2, 2, 2, 2, 1,
  1, 1, 1, 1, 1, 1, 1
};

// The following function tests count_painted
void test2() {
  printf("Test2:\n");
  int width = 5;
  int radius = 1;
  int col = 2;
  int row = 3;
  int coord = (row << 16) | (col & 0x0000ffff);
  int count = count_painted(test_wall1, width, radius, coord);
  printf("The count score at (2,3) is %d\n", count);
}

// The following function tests get_heat_map
void test3() {
  printf("Test3:\n");
  int width = 7;
  int radius = 1;
  int *heat_map = get_heat_map(test_wall2, width, radius);
  printf("Returned the correct address: %s\n", (heat_map == output_map) ? "true": "false");
  print_wall(output_map, width);
}

// void test4() {
  // Feel free to add more tests  
// }

int main() {
  test1();
  test2();
  test3();
  // test4();
}