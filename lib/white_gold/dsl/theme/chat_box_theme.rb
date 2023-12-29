require_relative 'widget_theme'
require_relative 'scrollbar_theme'

module Tgui
  class ChatBoxTheme < WidgetTheme
    DEFINED_ATTRIBUTES = {}

    theme_attr :borders, :outline
    theme_attr :padding, :outline
    theme_attr :background_color, :color
    theme_attr :border_color, :color
    theme_attr :texture_background, :texture
    theme_comp :scrollbar, ScrollbarTheme
    theme_attr :scrollbar_width, :float
    
  end
end