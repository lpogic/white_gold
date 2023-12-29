require_relative 'widget_theme'

module Tgui
  class ProgressBarTheme < WidgetTheme

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
end