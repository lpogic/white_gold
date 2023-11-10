require_relative 'group'
require_relative 'signal/signal_vector2f'

module Tgui
  class Panel < Group

    abi_signal :on_mouse_press, SignalVector2f
    abi_signal :on_mouse_release, SignalVector2f
    abi_signal :on_click, SignalVector2f
    abi_signal :on_double_click, SignalVector2f
    abi_signal :on_right_mouse_press, SignalVector2f
    abi_signal :on_right_mouse_release, SignalVector2f
    abi_signal :on_right_click, SignalVector2f
    
  end
end