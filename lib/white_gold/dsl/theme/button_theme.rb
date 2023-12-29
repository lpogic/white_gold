require_relative 'widget_theme'

module Tgui
  class ButtonTheme < WidgetTheme

    theme_attr :borders, :outline
    [ '', :_down, :_hover, :_down_hover, :_disabled, :_down_disabled, :_focused, :_down_focused ].each do |v|
      theme_attr "text_color#{v}".to_sym, :color
      theme_attr "background_color#{v}".to_sym, :color
      theme_attr "border_color#{v}".to_sym, :color
      theme_attr "texture#{v}".to_sym, :texture
      theme_attr "text_style#{v}".to_sym, :text_styles
    end
    theme_attr :text_outline_color, :color
    theme_attr :text_outline_thickness, :float
    theme_attr :rounded_border_radius, :float

  end
end