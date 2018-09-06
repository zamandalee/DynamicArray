require_relative "static_array"

class RingBuffer
  attr_reader :length

  def initialize
    @length = 0
    @capacity = 8
    @start_idx = 0
    @store = StaticArray.new(@capacity)
  end

  # O(1)
  def [](index)
    if index < length && index >= 0
      index = (index + @start_idx) % @capacity
      @store[index]
    else
      raise 'index out of bounds'
    end
  end

  # O(1)
  def []=(index, val)
    if index < @length && index >= 0
      index = (index + @start_idx) % @capacity
      @store[index] = val
      @length += 1
    else
      raise 'index out of bounds'
    end
  end

  # O(1)
  def pop
    if @length == 0
      raise 'index out of bounds'
    else
      @length -= 1
      @store[(@start_idx + @length) % @capacity]
    end
  end

  # O(1) ammortized
  def push(val)
    resize! if @length == @capacity

    @store[(@start_idx + @length) % @capacity] = val
    @length += 1
  end

  # O(1)
  def shift
    if @length == 0
      raise 'index out of bounds'
    else
      @start_idx += 1
      @length -= 1

      @store[@start_idx -1]
    end
  end

  # O(1) ammortized
  def unshift(val)
    resize! if @length == @capacity

    @start_idx -= 1
    @store[@start_idx % @capacity] = val

    @length += 1
  end

  protected
  attr_accessor :capacity, :start_idx, :store
  attr_writer :length

  def check_index(index)
  end

  def resize!
    old_store = @store
    @store = StaticArray.new(@capacity * 2)

    @capacity.times do |num|
      @store[num] = old_store[(@start_idx + num) % @capacity]
    end

    @capacity *= 2
    @start_idx = 0
  end
end
