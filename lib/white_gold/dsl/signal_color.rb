require_relative 'signal'

class Tgui
  class SignalColor < Signal
    def connect &b
      block_caller = Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_VOIDP]) do |ptr|
        b.(ptr.parse('Color'))
      end
      id = Private.connect(@pointer, block_caller)
      @@callback_storage[id] = block_caller
      return id
    end
  end
end