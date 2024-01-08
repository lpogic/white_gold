require_relative 'signal'

module Tgui
  class SignalVector2f < Signal
    def block_caller &b
      Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_VOIDP]) do |ptr|
        vector = @widget.abi_unpack Vector2f, ptr
        @widget.send! do
          b.(vector, @widget)
        end
      end
    end
  end
end