require_relative 'widget'
require_relative 'signal/signal_float'

module Tgui
  class Slider < Widget

    abi_attr :min, Float, :minimum
    abi_attr :max, Float, :maximum
    abi_attr :value, Float
    abi_attr :step, Float
    abi_attr :vertical?, "Boolean", :vertical_scroll

    def horizontal=(horizontal)
      self.vertical = !horizontal
    end

    def horizontal?
      !vertical?
    end

    abi_attr :inverted?, "Boolean", :inverted_direction
    abi_attr :scrollable?, "Boolean", :change_value_on_scroll
    abi_signal :on_value_change, SignalFloat
    
  end
end