require_relative 'clickable_widget'
require_relative 'signal/signal'
require_relative 'signal/signal_u_int'

module Tgui
  class ProgressBar < ClickableWidget

    abi_enum "FillDirection", :left_to_right, :right_to_left, :top_to_bottom, :bottom_to_top
    abi_attr :min, Float, :minimum
    abi_attr :max, Float, :maximum
    abi_attr :value, Float
    abi_attr :increment, Float, :increment_value
    abi_attr :text, String
    abi_attr :fill_direction, FillDirection
    abi_signal :on_value_change, SignalUInt
    abi_signal :on_full, Signal

  end
end