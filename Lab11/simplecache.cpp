#include "simplecache.h"

int SimpleCache::find(int index, int tag, int block_offset) {
  // read handout for implementation details
  for (auto itr : _cache) {
    if (index == itr.first) {
      for (auto it : itr.second){
        if (it.valid() && tag == it.tag()) {
          return it.get_byte(block_offset);
        }
      }
    }
  }
  return 0xdeadbeef;
}

void SimpleCache::insert(int index, int tag, char data[]) {
  // read handout for implementation details
  // keep in mind what happens when you assign in C++ (hint: Rule of Three)

  for (auto & itr : _cache[index]) {
    if (!itr.valid()) {
      itr.replace(tag,data);
      return;
    }
  }
  _cache[index][0].replace(tag, data);
}
