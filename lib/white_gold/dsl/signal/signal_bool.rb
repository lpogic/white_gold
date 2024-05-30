require_relative 'signal'

module Tgui
  class SignalBool < Signal

    def block_caller &b
      Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_INT]) do |int|
        bool = @widget.abi_unpack Boolean, int
        @widget.host! do
          b.(bool, @widget)
        end
      end
    end
    
  end
end