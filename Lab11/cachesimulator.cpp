//cachesimulator.cpp:
#include "cachesimulator.h"

Cache::Block* CacheSimulator::find_block(uint32_t address) const {
	/**
	* TODO
	*
	* 1. Use `_cache->get_blocks_in_set` to get all the blocks that could
	*    possibly have `address` cached.
	* 2. Loop through all these blocks to see if any one of them actually has
	*    `address` cached (i.e. the block is valid and the tags match).
	* 3. If you find the block, increment `_hits` and return a pointer to the
	*    block. Otherwise, return NULL.
	*/

	uint32_t index = extract_index(address, _cache->get_config());
	uint32_t tagToFind = extract_tag(address, _cache->get_config());

	vector<Cache::Block*> blah = _cache->get_blocks_in_set(index);

	for(int i = 0; i < blah.size(); i++){
		if( (tagToFind == blah[i]->get_tag()) && (blah[i]->is_valid())){
			_hits++;
			return blah[i];
		}
	}
	return NULL;
}

Cache::Block* CacheSimulator::bring_block_into_cache(uint32_t address) const {
	/**
	* TODO
	*
	* 1. Use `_cache->get_blocks_in_set` to get all the blocks that could
	*    cache `address`.
	* 2. Loop through all these blocks to find an invalid `block`. If found,
	*    skip to step 4.
	* 3. Loop through all these blocks to find the least recently used `block`.
	*    If the block is dirty, write it back to memory.
	* 4. Update the `block`'s tag. Read data into it from memory. Mark it as
	*    valid. Mark it as clean. Return a pointer to the `block`.
	*/

	uint32_t index = extract_index(address, _cache->get_config());
	uint32_t tag = extract_tag(address, _cache->get_config());

	vector<Cache::Block*> blah = _cache->get_blocks_in_set(index);
	uint32_t last_used = blah[0]->get_last_used_time();
	Cache::Block* recent = blah[0];

	for(int i = 0; i < blah.size(); i++){
		if(!blah[i]->is_valid()){
			blah[i]->set_tag(tag);
			blah[i]->read_data_from_memory(_memory);
			blah[i]->mark_as_valid();
			blah[i]->mark_as_clean();

			return blah[i];
		}

		if(blah[i]->get_last_used_time() < last_used){
			last_used = blah[i]->get_last_used_time();
			recent = blah[i];
		}

	}

	if(recent->is_dirty()){
		recent->write_data_to_memory(_memory);
	}

	recent->set_tag(tag);
	recent->read_data_from_memory(_memory);
	recent->mark_as_valid();
	recent->mark_as_clean();

	return recent;
}

uint32_t CacheSimulator::read_access(uint32_t address) const {
	/**
	* TODO
	*
	* 1. Use `find_block` to find the `block` caching `address`.
	* 2. If not found, use `bring_block_into_cache` cache `address` in `block`.
	* 3. Update the `last_used_time` for the `block`.
	* 4. Use `read_word_at_offset` to return the data at `address`.
	*/

	Cache::Block* blah = this->find_block(address);

	if(blah == NULL){
		blah = this->bring_block_into_cache(address);
	}

  _use_clock++;
  uint32_t lol = _use_clock.get_count();
	blah->set_last_used_time(lol);
	uint32_t offset = extract_block_offset(address, _cache->get_config());
  return blah->read_word_at_offset(offset);
}

void CacheSimulator::write_access(uint32_t address, uint32_t word) const {
	/**
	* TODO
	*
	* 1. Use `find_block` to find the `block` caching `address`.
	* 2. If not found
	*    a. If the policy is write allocate, use `bring_block_into_cache`.
	*    a. Otherwise, directly write the `word` to `address` in the memory
	*       using `_memory->write_word` and return.
	* 3. Update the `last_used_time` for the `block`.
	* 4. Use `write_word_at_offset` to to write `word` to `address`.
	* 5. a. If the policy is write back, mark `block` as dirty.
	*    b. Otherwise, write `word` to `address` in memory.
	*/

	Cache::Block* blah = this->find_block(address);
	if(this->find_block(address) == NULL){
		if(!_policy.is_write_allocate()){
			_memory->write_word(address, word);
		}
		else{
      blah = this->bring_block_into_cache(address);
			return;
		}
	}

  _use_clock++;

  uint32_t count = _use_clock.get_count();

	blah->set_last_used_time(count);
	uint32_t offset = extract_block_offset(address, _cache->get_config());

	blah->write_word_at_offset(word, offset);

	if(_policy.is_write_back()){
		blah->mark_as_dirty();
	}else{
		_memory->write_word(address, word);
	}
}
