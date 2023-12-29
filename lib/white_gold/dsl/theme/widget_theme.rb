require_relative 'theme_component'

module Tgui
  class WidgetTheme < ThemeComponent
    DEFINED_ATTRIBUTES = {}

    theme_attr :opacity, :float
    theme_attr :opacity_disabled, :float
    theme_attr :text_size, :float
    theme_attr :transparent_texture, :boolean

  end
end