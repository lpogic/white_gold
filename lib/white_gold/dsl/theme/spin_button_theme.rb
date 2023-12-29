require_relative 'widget_theme'

module Tgui
  class SpinButtonTheme < WidgetTheme

    theme_attr :borders, :outline
    theme_attr :border_between_arrows, :float
    theme_attr :background_color, :color
    theme_attr :background_color_hover, :color
    theme_attr :arrow_color, :color
    theme_attr :arrow_color_hover, :color
    theme_attr :border_color, :color
    theme_attr :texture_arrow_up, :texture
    theme_attr :texture_arrow_up_hover, :texture
    theme_attr :texture_arrow_down, :texture
    theme_attr :texture_arrow_down_hover, :texture

  end
end