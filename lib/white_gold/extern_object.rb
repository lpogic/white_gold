class Tgui
  class ExternObject  
    def initialize pointer:, autofree: true
      @pointer = pointer
      
      if autofree
        cl = self.class
        while !cl.respond_to?(:finalizer)
          cl = cl.superclass
        end
        ObjectSpace.define_finalizer(self, cl.finalizer(pointer))
      end
    end

    attr :pointer

    def self.finalizer pointer
      proc do
        Util.free(pointer)
      end
    end

    def self.enum *keywords, **indexed_keywords
      Enum.new *keywords, **indexed_keywords
    end

    def self.bit_enum zero, *keywords, **indexed_keywords
      Enum.new zero, **(keywords.each_with_index.map{[_1, 1 << _2]}.to_h), **indexed_keywords
    end

    @@callback_storage = {}

    def self.callback_storage=(callback_storage)
      @@callback_storage = callback_storage
    end

    class Enum
      def initialize *keywords, **indexed_keywords
        @symbol_to_int = keywords.each_with_index.to_h.merge indexed_keywords
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
  end
end