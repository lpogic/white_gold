class Enum
  def initialize *keywords, **indexed_keywords
    @symbol_to_int = keywords.each_with_index.to_h
    indexed_keywords.each do |k, i|
        @symbol_to_int[k] = Integer === i ? i : @symbol_to_int[i]
    end
    @int_to_symbol = @symbol_to_int.invert
  end

  attr_accessor :name

  def sym_to_i sym
    @symbol_to_int[sym] || raise("No value at #{sym}")
  end

  def i_to_sym i
    @int_to_symbol[i] || raise("No keyword at #{i}")
  end

  def [](k)
    k.is_a?(Integer) ? i_to_sym(k) : sym_to_i(k)
  end

  def pack *k
    k.map{ @symbol_to_int[_1] }.reduce(0, &:|)
  end

  def unpack m
    @int_to_symbol.filter{|k, v| k != 0 and m & k == k }.map{ _1[1] }
  end

  def symbols
    @symbol_to_int
  end
end