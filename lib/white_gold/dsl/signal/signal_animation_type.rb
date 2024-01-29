require_relative 'signal'

module Tgui
  class SignalAnimationType < Signal

    def block_caller
      block_caller = Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_INT]) do |animation_type|
        at = @widget.abi_unpack AnimationType, animation_type
        @widget.host! do
          b.(at, @widget)
        end
      end
    end
    
  end
end