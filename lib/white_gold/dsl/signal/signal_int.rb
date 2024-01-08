require_relative 'signal'

module Tgui
  class SignalInt < Signal

    def block_caller &b
      Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_VOIDP]) do |int|
        i = @widget.abi_unpack_integer int
        @widget.send! do
          b.(i, @widget)
        end
      end
    end

  end
end