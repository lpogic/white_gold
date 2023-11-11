require_relative 'clickable_widget'

module Tgui
  class SpinButton < ClickableWidget

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

    abi_signal :on_value_change, SignalFloat

  end
end