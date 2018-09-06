require_relative "static_array"

class DynamicArray
  attr_reader :length

  def initialize
    @length = 0
    @capacity = 8
    @store = StaticArray.new(@capacity)
  end

  # O(1)
  def [](index)
    if index < length && index >= 0
      @store[index]
    else
      raise 'index out of bounds'
    end
  end

  # O(1)
  def []=(index, value)
    if index < @length && index >= 0
      @store[index] = value
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
      @store[@length]
    end
  end

  # O(1) ammortized; O(n) worst case. Variable because of the possible
  # resize.
  def push(val)
    resize! if @length == @capacity

    @store[@length] = val
    @length += 1
  end

  # O(n): has to shift over all the elements.
  def shift
    if @length == 0
      raise 'index out of bounds'
    else
      old_store = @store.dup
      @store = StaticArray.new(@capacity)

      (1).upto(@length + 1).each do |num|
        @store[num - 1] = old_store[num]
      end

      @length -= 1
      old_store[0]
    end
  end

  # O(n): has to shift over all the elements.
  def unshift(val)
    resize! if @length == @capacity

    (@length - 1).downto(0).each do |num|
      @store[num + 1] = @store[num]
    end

    @store[0] = val
    @length += 1
  end

  protected
  attr_accessor :capacity, :store
  attr_writer :length

  def check_index(index)
  end

  # O(n): has to copy over all the elements to the new store.
  def resize!
    @capacity *= 2

    old_store = @store
    @store = StaticArray.new(@capacity)

    (@length - 1).downto(0).each do |num|
      @store[num] = old_store[num]
    end
  end
end
