class Enum
  def initialize *keywords, **indexed_keywords
    @symbol_to_int = keywords.each_with_index.to_h
    indexed_keywords.each do |k, i|
        @symbol_to_int[k] = Integer === i ? i : @symbol_to_int[i]
    end
    @int_to_symbol = @symbol_to_int.invert
  end

  def [](k)
    if k.is_a? Integer
      @int_to_symbol[k] || raise("No keyword at #{k}")
    else
      @symbol_to_int[k] || raise("No value at #{k}")
    end
  end

  def pack *k
    k.map{ @symbol_to_int[_1] }.reduce(0, &:|)
  end

  def unpack m
    @int_to_symbol.filter{|k, v| k != 0 and m & k == k }.map{ _1[1] }
  end
end

class Object
  def self.enum *keywords, **indexed_keywords
    Enum.new *keywords, **indexed_keywords
  end

  def self.bit_enum zero, *keywords, **indexed_keywords
    Enum.new zero, **(keywords.each_with_index.map{[_1, 1 << _2]}.to_h), **indexed_keywords
  end
end