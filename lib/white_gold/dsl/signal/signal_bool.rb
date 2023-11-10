require_relative 'signal'

module Tgui
  class SignalBool < Signal

    def block_caller &b
      Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_INT]) do |int|
        b.(int.odd?, @widget)
      end
    end
    
  end
end