require_relative 'clickable_widget'
require_relative 'signal/signal'
require_relative 'signal/signal_u_int'

module Tgui
  class ProgressBar < ClickableWidget
    FillDirection = enum :left_to_right, :right_to_left, :top_to_bottom, :bottom_to_top

    abi_attr :min, :minimum
    abi_attr :max, :maximum
    abi_attr :value
    abi_alias :increment, :increment_value
    abi_attr :text

    def fill_direction=(direction)
      _abi_set_fill_direction FillDirection[direction]
    end

    def fill_direction
      FillDirection[_abi_get_fill_direction]
    end

    abi_signal :on_value_change, SignalUInt
    abi_signal :on_full, Signal
  end
end