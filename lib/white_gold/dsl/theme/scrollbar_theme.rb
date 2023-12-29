require_relative 'widget_theme'

module Tgui
  class ScrollbarTheme < WidgetTheme

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
end