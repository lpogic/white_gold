require_relative 'signal'

module Tgui
  class SignalColor < Signal

    def block_caller &b
      Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_VOIDP]) do |ptr|
        b.(ptr.parse('Color'), @widget)
      end
    end
    
  end
end