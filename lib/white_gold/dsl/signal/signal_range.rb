require_relative 'signal'

module Tgui
  class SignalRange < Signal

    def block_caller &b
      Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_FLOAT, Fiddle::TYPE_FLOAT]) do |min, max|
        @widget.send! do
          b.(min..max, @widget)
        end
      end
    end
    
  end
end