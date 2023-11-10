require_relative 'widget'
require_relative 'signal/signal_float'

module Tgui
  class Slider < Widget

    abi_attr :min, :minimum
    abi_attr :max, :maximum
    abi_attr :value
    abi_attr :step
    abi_attr :vertical?, :vertical_scroll

    def horizontal=(horizontal)
      self.vertical = !horizontal
    end

    def horizontal?
      !vertical?
    end

    abi_attr :inverted?, :inverted_direction
    abi_attr :scrollable?, :change_value_on_scroll

    abi_signal :on_value_change, SignalFloat
  end
end