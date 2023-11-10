require_relative 'signal'

module Tgui
  class SignalString < Signal

    def block_caller &b
      Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_VOIDP]) do |str|
        b.(str.parse('char32_t'), @widget)
      end
    end
    
  end
end