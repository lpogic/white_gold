require_relative 'signal'

module Tgui
  class SignalVector2f < Signal
    def block_caller &b
      Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_VOIDP]) do |ptr|
        vector = ptr.parse('Vector2f')
        b.(vector.x, vector.y, @widget)
      end
    end
  end
end