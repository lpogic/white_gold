require_relative 'signal'

module Tgui
  class SignalBoolean < Signal

    def block_caller &b
      Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_INT]) do |int|
        b = @widget.abi_unpack "Boolean", int
        @widget.page.upon! @widget do
          b.(b, @widget)
        end
      end
    end
    
  end
end