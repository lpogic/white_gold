require_relative 'widget'
require_relative 'signal/signal_range'

module Tgui
  class RangeSlider < Widget

    abi_attr :min, :minimum
    abi_attr :max, :maximum
    abi_attr :selection_start
    abi_attr :selection_end
    abi_attr :step
    abi_signal :on_range_change, SignalRange
    
  end
end