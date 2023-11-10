require_relative 'widget'
require_relative 'signal/signal_float'

module Tgui
  class Knob < Widget

    abi_attr :start, :start_rotation
    abi_attr :end, :end_rotation
    abi_attr :min, :minimum
    abi_attr :max, :maximum
    abi_attr :value
    abi_attr :clockwise?, :clockwise_turning
    abi_signal :on_change, SignalFloat, :on_value_change

  end
end