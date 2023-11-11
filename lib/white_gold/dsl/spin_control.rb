require_relative 'subwidget_container'

module Tgui
  class SpinControl < SubwidgetContainer

    abi_attr :min, :minimum
    abi_attr :max, :maximum
    abi_attr :value
    abi_attr :step
    abi_attr :decimals, :decimal_places
    abi_attr :wide_arrows?

    abi_signal :on_value_change, SignalFloat
  end
end