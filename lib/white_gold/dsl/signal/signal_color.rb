require_relative 'signal'

module Tgui
  class SignalColor < Signal

    def block_caller &b
      Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_VOIDP]) do |ptr|
        c = @widget.abi_unpack Color, ptr
        @widget.host! do
          b.(c, @widget)
        end
      end
    end
    
  end
end