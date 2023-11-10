require_relative 'signal'

module Tgui
  class SignalUInt < Signal

    def block_caller &b
      Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_INT]) do |uint|
        b.(uint, @widget)
      end
    end

  end
end