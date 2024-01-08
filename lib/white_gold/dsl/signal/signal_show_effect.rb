require_relative 'signal'

module Tgui
  class SignalShowEffect < Signal

    def block_caller &b
      Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_INT, Fiddle::TYPE_INT]) do |show_effect_type, shown|
        effect_type = @widget.abi_unpack ShowEffectType, show_effect_type
        shown = @widget.abi_unpack Boolean, shown
        @widget.send! do
          b.(effect_type, shown, @widget)
        end
      end
    end
    
  end
end