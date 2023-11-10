require_relative 'signal'

module Tgui
  class SignalPointer < Signal

    def block_caller &b
      Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_VOIDP]) do |pointer|
        b.(pointer, @widget)
      end
    end

  end
end