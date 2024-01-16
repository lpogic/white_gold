require_relative 'group'
require_relative 'signal/signal_vector2f'

module Tgui
  class Panel < Group

    class Theme < Group::Theme
      theme_attr :borders, :outline
      theme_attr :border_color, :color
      theme_attr :background_color, :color
      theme_attr :texture_background, :texture
      theme_attr :rounded_border_radius, :float
    end

    abi_signal :on_mouse_press, SignalVector2f
    abi_signal :on_mouse_release, SignalVector2f
    abi_signal :on_click, SignalVector2f
    abi_signal :on_double_click, SignalVector2f
    abi_signal :on_right_mouse_press, SignalVector2f
    abi_signal :on_right_mouse_release, SignalVector2f
    abi_signal :on_right_click, SignalVector2f
    
  end
end