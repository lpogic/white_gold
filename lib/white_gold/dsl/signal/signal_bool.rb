require_relative 'signal'

module Tgui
  class SignalBool < Signal
    def connect &b
      block_caller = Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_INT]) do |int|
        b.(int.odd?)
      end
      id = _abi_connect(@pointer, block_caller)
      @@callback_storage[id] = block_caller
      return id
    end
  end
end