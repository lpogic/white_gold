require_relative 'signal'

module Tgui
  class SignalRange < Signal
    def connect &b
      block_caller = Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_FLOAT, Fiddle::TYPE_FLOAT], &b)
      id = _abi_connect(@pointer, block_caller)
      @@callback_storage[id] = block_caller
      return id
    end
  end
end