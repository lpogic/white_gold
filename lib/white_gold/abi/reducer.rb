class Reducer
  def initialize reduction, &block
    @reduction = reduction
    @block = block
  end

  def call *a
    block.call *a
  end

  attr :reduction
end