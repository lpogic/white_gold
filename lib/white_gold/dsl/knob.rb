require_relative 'widget'
require_relative 'signal/signal_float'

module Tgui
  class Knob < Widget

    abi_attr :start, Float, :start_rotation
    abi_attr :end, Float, :end_rotation
    abi_attr :min, Float, :minimum
    abi_attr :max, Float, :maximum
    abi_attr :value, Float
    abi_attr :clockwise?, :clockwise_turning
    abi_signal :on_change, SignalFloat, :on_value_change

  end
end