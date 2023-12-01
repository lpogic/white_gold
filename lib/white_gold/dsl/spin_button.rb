require_relative 'clickable_widget'

module Tgui
  class SpinButton < ClickableWidget

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

    abi_signal :on_value_change, SignalFloat

  end
end