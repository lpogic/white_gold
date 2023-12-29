require_relative 'widget_theme'
require_relative 'button_theme'

module Tgui
  class MessageBoxTheme < WidgetTheme

    theme_attr :text_color, :color
    theme_comp :button, ButtonTheme

  end
end