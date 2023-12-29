require_relative 'widget_theme'
require_relative 'scrollbar_theme'

module Tgui
  class TextAreaTheme < WidgetTheme

    theme_attr :borders, :outline
    theme_attr :padding, :outline
    theme_attr :background_color, :color
    theme_attr :text_color, :color
    theme_attr :default_text_color, :color
    theme_attr :selected_text_color, :color
    theme_attr :selected_text_background_color, :color
    theme_attr :border_color, :color
    theme_attr :caret_color, :color
    theme_attr :texture_background, :texture
    theme_attr :caret_width, :float
    theme_comp :scrollbar, ScrollbarTheme
    theme_attr :scrollbar_width, :float

  end
end