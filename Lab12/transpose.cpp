#include <algorithm>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "transpose.h"

// will be useful
// remember that you shouldn't go over SIZE
using std::min;

// modify this function to add tiling
void
transpose_tiled(int **src, int **dest) {
    for (int i = 0; i < SIZE; i +=32) {
        for (int j = 0; j < SIZE; j +=32) {
            for (int x = i; x < min(i + 32, SIZE); x ++) {
                for (int y = j; y < min(j + 32, SIZE); y ++) {
                    dest[x][y] = src[y][x];
                }
            }
        }
    }
}
