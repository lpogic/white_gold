require_relative 'widget'
require_relative 'signal/signal_range'

module Tgui
  class RangeSlider < Widget

    abi_attr :min, Float, :minimum
    abi_attr :max, Float, :maximum
    abi_attr :selection_start, Float
    abi_attr :selection_end, Float
    abi_attr :step, Float
    abi_signal :on_range_change, SignalRange
    
  end
end