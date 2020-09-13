#include <stdio.h>
#include <stdlib.h>
#include "filter.h"

// modify this code by fusing loops together
void
filter_fusion(pixel_t **image1, pixel_t **image2) {
  for (int i = 1; i < SIZE - 1; i ++) {
      filter1(image1, image2, i);

      if(i+1<SIZE-2){
          filter2(image1, image2, i+1);
      }

      if(i<SIZE-5){
          filter3(image2, i);
      }
  }
}

// modify this code by adding software prefetching
void
filter_prefetch(pixel_t **image1, pixel_t **image2) {
    for (int i = 1; i < SIZE - 1; i ++) {
        filter1(image1, image2, i);
        __builtin_prefetch(image1[i+14],0);
        __builtin_prefetch(image2[i+14],1);
    }

    for (int i = 2; i < SIZE - 2; i ++) {
        filter2(image1, image2, i);
        __builtin_prefetch(image1[i+14],0);
        __builtin_prefetch(image2[i+14],1);
    }

    for (int i = 1; i < SIZE - 5; i ++) {
        filter3(image2, i);
        __builtin_prefetch(image2[i+14]);
    }
}

// modify this code by adding software prefetching and fusing loops together
void
filter_all(pixel_t **image1, pixel_t **image2) {
  for (int i = 1; i < SIZE - 1; i ++) {
    filter1(image1, image2, i);

    if(i+1<SIZE-2){
        filter2(image1, image2, i+1);
    }

    if(i>=6){
        filter3(image2, i-5);
    }
      __builtin_prefetch(image1[i+15],0);
      __builtin_prefetch(image2[i+15],1);
  }
}
