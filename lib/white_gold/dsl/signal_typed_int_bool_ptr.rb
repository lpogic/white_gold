require_relative 'signal'
require_relative '../convention/bool_property'

class Tgui
  class SignalTypedIntBoolPtr < Signal
    def connect &b
      block_caller = Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_INT, Fiddle::TYPE_VOIDP]) do |index, ptr|
        b.(index, BoolProperty.new(ptr))
      end
      id = Private.connect(@pointer, block_caller)
      @@callback_storage[id] = block_caller
      return id
    end
  end
end