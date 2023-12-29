require_relative 'widget_theme'

module Tgui
  class ChildWindowTheme < WidgetTheme

    theme_attr :borders, :outline
    theme_attr :title_bar_height, :float
    theme_attr :title_bar_color, :color
    theme_attr :title_color, :color
    theme_attr :background_color, :color
    theme_attr :border_color, :color
    theme_attr :border_color_focused, :color
    theme_attr :border_below_title_bar, :float
    theme_attr :distance_to_side, :float
    theme_attr :padding_between_buttons, :float
    theme_attr :minimum_resizable_border_width, :float
    theme_attr :show_text_on_title_buttons, :boolean
    theme_attr :texture_title_bar, :texture
    theme_attr :texture_background, :texture
    theme_comp :close_button, ButtonTheme
    theme_comp :maximize_button, ButtonTheme
    theme_comp :minimize_button, ButtonTheme

  end
end