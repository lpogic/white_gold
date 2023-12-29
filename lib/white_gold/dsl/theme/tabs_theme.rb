require_relative 'widget_theme'

module Tgui
  class TabsTheme < WidgetTheme

    theme_attr :borders, :outline
    theme_attr :background_color, :color
    theme_attr :background_color_hover, :color
    theme_attr :background_color_disabled, :color
    theme_attr :selected_background_color, :color
    theme_attr :selected_background_color_hover, :color
    theme_attr :text_color, :color
    theme_attr :text_color_hover, :color
    theme_attr :text_color_disabled, :color
    theme_attr :selected_text_color, :color
    theme_attr :selected_text_color_hover, :color
    theme_attr :border_color, :color
    theme_attr :border_color_hover, :color
    theme_attr :selected_border_color, :color
    theme_attr :selected_border_color_hover, :color
    theme_attr :texture_tab, :texture
    theme_attr :texture_tab_hover, :texture
    theme_attr :texture_selected_tab, :texture
    theme_attr :texture_selected_tab_hover, :texture
    theme_attr :texture_disabled_tab, :texture
    theme_attr :distance_to_side, :float
  
  end
end