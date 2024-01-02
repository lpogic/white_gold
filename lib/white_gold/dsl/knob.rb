require_relative 'widget'
require_relative 'signal/signal_float'

module Tgui
  class Knob < Widget

    class Theme < Widget::Theme
      theme_attr :borders, :outline
      theme_attr :background_color, :color
      theme_attr :thumb_color, :color
      theme_attr :border_color, :color
      theme_attr :texture_background, :texture
      theme_attr :texture_foreground, :texture
      theme_attr :image_rotation, :float
    end

    abi_attr :start, Float, :start_rotation
    abi_attr :end, Float, :end_rotation
    abi_attr :min, Float, :minimum
    abi_attr :max, Float, :maximum
    abi_attr :value, Float
    abi_attr :clockwise?, :clockwise_turning
    abi_signal :on_change, SignalFloat, :on_value_change

  end
end