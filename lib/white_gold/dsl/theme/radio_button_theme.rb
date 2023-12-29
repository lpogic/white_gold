require_relative 'widget_theme'

module Tgui
  class RadioButtonTheme < WidgetTheme

    theme_attr :borders, :outline
    theme_attr :text_distance_ratio, :float
    [ '', :_hover, :_disabled, :_checked, :_checked_hover, :_checked_disabled ].each do |v|
      theme_attr "text_color#{v}".to_sym, :color
      theme_attr "background_color#{v}".to_sym, :color
      theme_attr "border_color#{v}".to_sym, :color
    end
    theme_attr :border_color_focused, :color
    theme_attr :border_color_checked_focused, :color
    theme_attr :check_color, :color
    theme_attr :check_color_hover, :color
    theme_attr :check_color_disabled, :color
    theme_attr :texture_unchecked, :texture
    theme_attr :texture_unchecked_hover, :texture
    theme_attr :texture_unchecked_disabled, :texture
    theme_attr :texture_unchecked_focused, :texture
    theme_attr :texture_checked, :texture
    theme_attr :texture_checked_hover, :texture
    theme_attr :texture_checked_disabled, :texture
    theme_attr :texture_checked_focused, :texture
    theme_attr :text_style, :text_styles
    theme_attr :text_style_checked, :text_styles

  end
end