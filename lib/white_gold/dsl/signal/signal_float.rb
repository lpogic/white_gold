require_relative 'signal'

module Tgui
  class SignalFloat < Signal

    def block_caller &b
      Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_FLOAT]) do |float|
        f = @widget.abi_unpack_float float
        @widget.send! do
          b.(f, @widget)
        end
      end
    end

  end
end