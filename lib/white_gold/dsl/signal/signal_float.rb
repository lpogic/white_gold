require_relative 'signal'

module Tgui
  class SignalFloat < Signal

    def block_caller &b
      Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_FLOAT]) do |float|
        b.(float, @widget)
      end
    end

  end
end