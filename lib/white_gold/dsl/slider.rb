require_relative 'widget'
require_relative 'signal/signal_float'

module Tgui
  class Slider < Widget

    class Theme < Widget::Theme
      theme_attr :borders, :outline
      theme_attr :track_color, :color
      theme_attr :track_color_hover, :color
      theme_attr :thumb_color, :color
      theme_attr :thumb_color_hover, :color
      theme_attr :border_color, :color
      theme_attr :border_color_hover, :color
      theme_attr :texture_track, :texture
      theme_attr :texture_track_hover, :texture
      theme_attr :texture_thumb, :texture
      theme_attr :texture_thumb_hover, :texture
      theme_attr :thumb_within_track, :boolean
    end

    abi_attr :min, Float, :minimum
    abi_attr :max, Float, :maximum
    abi_attr :value, Float
    abi_attr :step, Float
    abi_attr :vertical?, Boolean, :vertical_scroll

    def horizontal=(horizontal)
      self.vertical = !horizontal
    end

    def horizontal?
      !vertical?
    end

    abi_attr :inverted?, Boolean, :inverted_direction
    abi_attr :scrollable?, Boolean, :change_value_on_scroll
    abi_signal :on_value_change, SignalFloat
    
  end
end