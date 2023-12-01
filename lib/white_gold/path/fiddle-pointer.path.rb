module Fiddle
  class Pointer
    def parse type
      case type
      when 'Vector2u'
        v = Tgui::Abi::Vector2u.new self
        ObjectSpace.define_finalizer(v, Tgui::ExternObject.proc.finalizer(self))
        v
      else
        self
      end
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