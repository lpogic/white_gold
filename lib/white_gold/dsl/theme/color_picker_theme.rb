require_relative 'widget_theme'
require_relative 'button_theme'
require_relative 'label_theme'
require_relative 'slider_theme'

module Tgui
  class ColorPickerTheme < WidgetTheme

    theme_comp :button, ButtonTheme
    theme_comp :label, LabelTheme
    theme_comp :slider, SliderTheme

  end
end