require_relative 'widget'
require_relative 'signal/signal_u_int'

module Tgui
  class Scrollbar < Widget

    class Theme < Widget::Theme
      theme_attr :track_color, :color
      theme_attr :track_color_hover, :color
      theme_attr :thumb_color, :color
      theme_attr :thumb_color_hover, :color
      theme_attr :arrow_background_color, :color
      theme_attr :arrow_background_color_hover, :color
      theme_attr :arrow_color, :color
      theme_attr :arrow_color_hover, :color
      theme_attr :texture_track, :texture
      theme_attr :texture_track_hover, :texture
      theme_attr :texture_thumb, :texture
      theme_attr :texture_thumb_hover, :texture
      theme_attr :texture_arrow_up, :texture
      theme_attr :texture_arrow_up_hover, :texture
      theme_attr :texture_arrow_down, :texture
      theme_attr :texture_arrow_down_hover, :texture
    end

    abi_enum "Policy", :auto, :always, :never

    abi_attr :max, Integer, :maximum
    abi_attr :value, Integer
    abi_attr :viewport_size, Integer
    abi_attr :speed, Integer, :scroll_amount
    abi_attr :auto_hide?
    abi_attr :vertical?, Boolean, :vertical_scroll

    def horizontal=(horizontal)
      self.vertical = !horizontal
    end

    def horizontal?
      !vertical?
    end

    abi_def :default_width, :get_, nil => Float
    abi_signal :on_value_change, SignalUInt
    
  end
end