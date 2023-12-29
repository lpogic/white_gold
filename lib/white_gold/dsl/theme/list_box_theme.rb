require_relative 'widget_theme'

module Tgui
  class ListBoxTheme < WidgetTheme

    theme_attr :borders, :outline
    theme_attr :padding, :outline
    theme_attr :text_style, :text_styles
    theme_attr :selected_text_style, :text_styles
    theme_attr :background_color, :color
    theme_attr :background_color_hover, :color
    theme_attr :selected_background_color, :color
    theme_attr :selected_background_color_hover, :color
    theme_attr :text_color, :color
    theme_attr :text_color_hover, :color
    theme_attr :selected_text_color, :color
    theme_attr :selected_text_color_hover, :color
    theme_attr :border_color, :color
    theme_attr :texture_background, :texture
    theme_comp :scrollbar, ScrollbarTheme
    theme_attr :scrollbar_width, :float
  
  end
end