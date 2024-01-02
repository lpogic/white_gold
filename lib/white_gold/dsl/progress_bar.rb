require_relative 'clickable_widget'
require_relative 'signal/signal'
require_relative 'signal/signal_u_int'

module Tgui
  class ProgressBar < ClickableWidget

    class Theme < Widget::Theme
      theme_attr :borders, :outline
      theme_attr :text_color, :color
      theme_attr :text_color_filled, :color
      theme_attr :background_color, :color
      theme_attr :fill_color, :color
      theme_attr :border_color, :color
      theme_attr :texture_background, :texture
      theme_attr :texture_fill, :texture
      theme_attr :text_style, :text_styles
      theme_attr :text_outline_color, :color
      theme_attr :text_outline_thickness, :float
    end

    abi_enum "FillDirection", :left_to_right, :right_to_left, :top_to_bottom, :bottom_to_top
    abi_attr :min, Float, :minimum
    abi_attr :max, Float, :maximum
    abi_attr :value, Float
    abi_attr :increment, Float, :increment_value
    abi_attr :text, String
    abi_attr :fill_direction, FillDirection
    abi_signal :on_value_change, SignalUInt
    abi_signal :on_full, Signal

  end
end