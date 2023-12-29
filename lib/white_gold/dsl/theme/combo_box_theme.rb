require_relative 'widget_theme'
require_relative 'list_box_theme'

module Tgui
  class ComboBoxTheme < WidgetTheme

    theme_attr :borders, :outline
    theme_attr :padding, :outline
    theme_attr :text_style, :text_styles
    theme_attr :default_text_style, :text_styles
    theme_attr :background_color, :color
    theme_attr :background_color_disabled, :color
    theme_attr :text_color, :color
    theme_attr :text_color_disabled, :color
    theme_attr :default_text_color, :color
    theme_attr :arrow_background_color, :color
    theme_attr :arrow_background_color_disabled, :color
    theme_attr :arrow_background_color_hover, :color
    theme_attr :arrow_color, :color
    theme_attr :arrow_color_hover, :color
    theme_attr :arrow_color_disabled, :color
    theme_attr :texture_background, :texture
    theme_attr :texture_background_disabled, :texture
    theme_attr :border_color, :color
    theme_attr :texture_background, :texture
    theme_attr :texture_background_disabled, :texture
    theme_attr :texture_arrow, :texture
    theme_attr :texture_arrow_hover, :texture
    theme_attr :texture_arrow_disabled, :texture
    theme_comp :list_box, ListBoxTheme
    
  end
end