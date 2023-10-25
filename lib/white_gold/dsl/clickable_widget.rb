require_relative 'widget'
require_relative 'signal/signal_vector2f'

module Tgui
  class ClickableWidget < Widget

    abi_signal :on_click, Tgui::SignalVector2f
    abi_signal :on_mouse_press, Tgui::SignalVector2f
    abi_signal :on_mouse_release, Tgui::SignalVector2f
    abi_signal :on_right_click, Tgui::SignalVector2f
    abi_signal :on_right_mouse_press, Tgui::SignalVector2f
    abi_signal :on_right_mouse_release, Tgui::SignalVector2f
    
  end
end