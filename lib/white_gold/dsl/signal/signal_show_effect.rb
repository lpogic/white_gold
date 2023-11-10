require_relative 'signal'

module Tgui
  class SignalShowEffect < Signal

    def block_caller &b
      Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_INT, Fiddle::TYPE_INT]) do |show_effect_type, shown|
        b.(ShowEffectType[int], shown.odd?, @widget)
      end
    end
    
  end
end