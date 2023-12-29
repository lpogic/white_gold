require_relative 'widget_theme'

module Tgui
  class KnobTheme < WidgetTheme

    theme_attr :borders, :outline
    theme_attr :background_color, :color
    theme_attr :thumb_color, :color
    theme_attr :border_color, :color
    theme_attr :texture_background, :texture
    theme_attr :texture_foreground, :texture
    theme_attr :image_rotation, :float

  end
end