require_relative 'signal'

module Tgui
  class SignalString < Signal

    def block_caller &b
      Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_VOIDP]) do |str|
        string = @widget.abi_unpack_string(str)
        @widget.host! do
          b.(string, @widget)
        end
      end
    end
    
  end
end