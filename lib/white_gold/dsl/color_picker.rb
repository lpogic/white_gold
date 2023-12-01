require_relative 'child_window'
require_relative 'signal/signal_color'

module Tgui
  class ColorPicker < ChildWindow

    abi_attr :color, Color
    abi_signal :on_color_change, SignalColor
    abi_signal :on_ok_press, SignalColor

  end
end