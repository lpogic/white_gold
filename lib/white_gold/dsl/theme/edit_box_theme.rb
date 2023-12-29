require_relative 'widget_theme'

module Tgui
  class EditBoxTheme < WidgetTheme

    theme_attr :text_style, :text_styles
    theme_attr :default_text_style, :text_styles
    theme_attr :borders, :outline
    theme_attr :padding, :outline
    theme_attr :caret_width, :float
    theme_attr :text_color, :color
    theme_attr :text_color_disabled, :color
    theme_attr :text_color_focused, :color
    theme_attr :selected_text_color, :color
    theme_attr :selected_text_background_color, :color
    theme_attr :default_text_color, :color
    theme_attr :background_color, :color
    theme_attr :background_color_hover, :color
    theme_attr :background_color_disabled, :color
    theme_attr :background_color_focused, :color
    theme_attr :caret_color, :color
    theme_attr :caret_color_hover, :color
    theme_attr :caret_color_focused, :color
    theme_attr :border_color, :color
    theme_attr :border_color_hover, :color
    theme_attr :border_color_disabled, :color
    theme_attr :border_color_focused, :color
    theme_attr :texture, :texture
    theme_attr :texture_hover, :texture
    theme_attr :texture_disabled, :texture
    theme_attr :texture_focused, :texture

  end
end