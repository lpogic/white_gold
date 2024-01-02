require_relative 'child_window'
require_relative 'button'
require_relative 'label'
require_relative 'slider'
require_relative 'signal/signal_color'

module Tgui
  class ColorPicker < ChildWindow

    class Theme < ChildWindow::Theme
      theme_comp :button, Button::Theme
      theme_comp :label, Label::Theme
      theme_comp :slider, Slider::Theme
    end

    abi_attr :color, Color
    abi_signal :on_color_change, SignalColor
    abi_signal :on_ok_press, SignalColor

  end
end