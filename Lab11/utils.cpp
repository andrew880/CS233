#include "utils.h"

uint32_t extract_tag(uint32_t address, const CacheConfig& cache_config) {
  // TODO

  uint32_t tag = cache_config.get_num_tag_bits();
  uint32_t shift = 32 - tag;

  return address>> shift;

}

uint32_t extract_index(uint32_t address, const CacheConfig& cache_config) {
  // TODO
  uint32_t index = cache_config.get_num_index_bits();
  uint32_t offset = cache_config.get_num_block_offset_bits();

  uint32_t blah = (1 << index);

  blah -= 1;

  return (address >> offset)& blah;
}

uint32_t extract_block_offset(uint32_t address, const CacheConfig& cache_config) {
  // TODO
  uint32_t offset = cache_config.get_num_block_offset_bits();
  uint32_t blah = (1<< offset);
  blah -= 1;

  return address & blah;
}
