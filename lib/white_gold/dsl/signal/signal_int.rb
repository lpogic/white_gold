require_relative 'signal'

module Tgui
  class SignalInt < Signal

    def block_caller &b
      Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_VOIDP]) do |int|
        b.(int, @widget)
      end
    end

  end
end