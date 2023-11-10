require_relative 'widget'
require_relative 'signal/signal_u_int'

module Tgui
  class Scrollbar < Widget

    Policy = enum :auto, :always, :never

    abi_attr :max, :maximum
    abi_attr :value
    abi_attr :viewport_size
    abi_attr :speed, :scroll_amount
    abi_attr :auto_hide?
    abi_attr :vertical?, :vertical_scroll

    def horizontal=(horizontal)
      self.vertical = !horizontal
    end

    def horizontal?
      !vertical?
    end

    abi_alias :default_width

    abi_signal :on_value_change, SignalUInt
  end
end