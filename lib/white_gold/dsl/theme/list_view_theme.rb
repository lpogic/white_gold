require_relative 'widget_theme'

module Tgui
  class ListViewTheme < WidgetTheme

    theme_attr :borders, :outline
    theme_attr :padding, :outline
    theme_attr :background_color, :color
    theme_attr :background_color_hover, :color
    theme_attr :selected_background_color, :color
    theme_attr :selected_background_color_hover, :color
    theme_attr :text_color, :color
    theme_attr :text_color_hover, :color
    theme_attr :selected_text_color, :color
    theme_attr :selected_text_color_hover, :color
    theme_attr :header_background_color, :color
    theme_attr :header_text_color, :color
    theme_attr :border_color, :color
    theme_attr :separator_color, :color
    theme_attr :grid_lines_color, :color
    theme_attr :texture_header_background, :texture
    theme_attr :texture_background, :texture
    theme_comp :scrollbar, ScrollbarTheme
    theme_attr :scrollbar_width, :float
  
  end
end