require_relative 'widget_theme'

module Tgui
  class SliderTheme < WidgetTheme

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
end