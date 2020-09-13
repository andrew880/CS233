#include "cacheblock.h"

uint32_t Cache::Block::get_address() const {
  // TODO
  uint32_t tagBits = _cache_config.get_num_tag_bits();
	uint32_t offsetBits = _cache_config.get_num_block_offset_bits();

	uint32_t returnIndex = (_index << offsetBits);
	uint32_t returnTag = (_tag << (32 - tagBits));

  return (returnTag | returnIndex);
}
