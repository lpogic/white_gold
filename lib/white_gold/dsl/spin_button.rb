require_relative 'clickable_widget'
require_relative 'signal/signal_float'

module Tgui
  class SpinButton < ClickableWidget

    class Theme < Widget::Theme
      theme_attr :borders, :outline
      theme_attr :border_between_arrows, :float
      theme_attr :background_color, :color
      theme_attr :background_color_hover, :color
      theme_attr :arrow_color, :color
      theme_attr :arrow_color_hover, :color
      theme_attr :border_color, :color
      theme_attr :texture_arrow_up, :texture
      theme_attr :texture_arrow_up_hover, :texture
      theme_attr :texture_arrow_down, :texture
      theme_attr :texture_arrow_down_hover, :texture
    end

    abi_attr :min, Float, :minimum
    abi_attr :max, Float, :maximum
    abi_attr :value, Float
    abi_attr :step, Float
    abi_attr :vertical?, Boolean, :vertical_scroll

    def horizontal=(horizontal)
      self.vertical = !horizontal
    end

    def horizontal?
      !vertical?
    end

    abi_signal :on_value_change, SignalFloat

  end
end
