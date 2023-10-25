require_relative 'signal'

module Tgui
  class SignalItemHierarchy < Signal
    def connect &b
      block_caller = Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_VOIDP]) do |vector|
        path = []
        loader = Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_VOIDP]) do |str|
          path << str.parse('char32_t')
        end
        SignalItemHierarchy.fetch_path vector, loader
        b.(path)
      end
      id = _abi_connect(@pointer, block_caller)
      @@callback_storage[id] = block_caller
      return id
    end
  end
end