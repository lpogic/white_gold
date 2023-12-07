require_relative 'signal'

module Tgui
  class SignalString < Signal

    def block_caller &b
      Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_VOIDP]) do |str|
        b.(@widget.abi_unpack_string(str), @widget)
      end
    end
    
  end
end