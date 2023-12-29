require_relative 'widget_theme'

module Tgui
  class MenuBarTheme < WidgetTheme

    theme_attr :background_color, :color
    theme_attr :selected_background_color, :color
    theme_attr :text_color, :color
    theme_attr :selected_text_color, :color
    theme_attr :text_color_disabled, :color
    theme_attr :separator_color, :color
    theme_attr :texture_background, :texture
    theme_attr :texture_item_background, :texture
    theme_attr :texture_selected_item_background, :texture
    theme_attr :distance_to_side, :float
    theme_attr :separator_thickness, :float
    theme_attr :separator_vertical_padding, :float
    theme_attr :separator_side_padding, :float

  end
end