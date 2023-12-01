require_relative 'subwidget_container'

module Tgui
  class SpinControl < SubwidgetContainer

    abi_attr :min, Float, :minimum
    abi_attr :max, Float, :maximum
    abi_attr :value, Float
    abi_attr :step, Float
    abi_attr :decimals, Integer, :decimal_places
    abi_attr :wide_arrows?
    abi_signal :on_value_change, SignalFloat
    
  end
end