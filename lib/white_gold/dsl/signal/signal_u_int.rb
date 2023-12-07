require_relative 'signal'

module Tgui
  class SignalUInt < Signal

    def block_caller &b
      Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_INT]) do |uint|
        int = @widget.abi_unpack Integer, uint
        @widget.page.upon! @widget do
          b.(int, @widget)
        end
      end
    end

  end
end