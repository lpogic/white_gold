require_relative 'signal'

class Tgui
  class SignalItem < Signal
    def connect &b
      block_caller = Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP]) do |str1, str2|
        b.(str1.parse('char32_t'), str2.parse('char32_t'))
      end
      id = Private.connect(@pointer, block_caller)
      @@callback_storage[id] = block_caller
      return id
    end
  end
end