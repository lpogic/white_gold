module Fiddle
  class Pointer
    def parse type
      case type
      when 'char32_t'
        utf32_to_s
      when 'Vector2f'
        v = Tgui::Abi::Vector2f.new self
        ObjectSpace.define_finalizer(v, Tgui::ExternObject.finalizer(self))
        v
      when 'Vector2u'
        v = Tgui::Abi::Vector2u.new self
        ObjectSpace.define_finalizer(v, Tgui::ExternObject.finalizer(self))
        v
      when 'UIntRect'
        v = Tgui::Abi::UIntRect.new self
        ObjectSpace.define_finalizer(v, Tgui::ExternObject.finalizer(self))
        v
      when 'Color'
        Tgui::Color.new pointer: self
      when 'Texture'
        Tgui::Texture.new pointer: self
      when 'Font'
        Tgui::Font.new pointer: self
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

    def set value = true
      case value
      when Integer
        self[0] = value
      when true
        self[0] = 1
      when false
        self[0] = 0
      else raise "Invalid argument #{value}"
      end
    end

    def unset
      set false
    end
  end
end