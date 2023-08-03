module Fiddle
  class Pointer
    def parse type
      case type
      when 'char32_t'
        utf32_to_s
      when 'Vector2f'
        v = Tgui::Abi::Vector2f.new self
        ObjectSpace.define_finalizer(v, ExternObject.finalizer(self))
        v
      when 'Color'
        Tgui::Color.new pointer: self
      else
        self
      end
    end

    def utf32_to_s
      a = []
      (0..).each do |i|
        i *= 4
        ch = (self[i]) | (self[i + 1] << 8) | (self[i + 2] << 16) | (self[i + 3] << 24)
        break if ch == 0
        a << ch
      end
      raise "deleted string!" if a[0] == 572653601
      a.pack("N*").encode("UTF-8", "UTF-32BE")
    end
  end
end

class Numeric
  def pc
    "#{self}%"
  end

  def px
    "#{self}"
  end
end