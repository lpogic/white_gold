require_relative 'widget_theme'
require_relative 'scrollbar_theme'

module Tgui
  class TreeViewTheme < WidgetTheme

    theme_attr :borders, :outline
    theme_attr :padding, :outline
    theme_attr :background_color, :color
    theme_attr :background_color_hover, :color
    theme_attr :selected_background_color, :color
    theme_attr :selected_background_color_hover, :color
    theme_attr :border_color, :color
    theme_attr :text_color, :color
    theme_attr :text_color_hover, :color
    theme_attr :selected_text_color, :color
    theme_attr :selected_text_color_hover, :color
    theme_comp :scrollbar, ScrollbarTheme
    theme_attr :scrollbar_width, :float
    theme_attr :texture_background, :texture
    theme_attr :texture_branch_expanded, :texture
    theme_attr :texture_branch_collapsed, :texture
    theme_attr :texture_leaf, :texture
  
  end
end