require_relative 'signal'

module Tgui
  class SignalString < Signal
    def connect &b
      block_caller = Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_VOIDP]) do |str|
        b.(str.parse('char32_t'))
      rescue Encoding::InvalidByteSequenceError
        p "error"
      end
      id = _abi_connect(@pointer, block_caller)
      @@callback_storage[id] = block_caller
      return id
    end
  end
end