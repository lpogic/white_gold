require_relative 'signal'

class Tgui
  class SignalVector2f < Signal
    def connect &b
      block_caller = Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_VOIDP]) do |ptr|
        b.(ptr.parse('Vector2f'))
      end
      id = Private.connect(@pointer, block_caller)
      @@callback_storage[id] = block_caller
      return id
    end
  end
end