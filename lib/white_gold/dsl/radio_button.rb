require_relative 'clickable_widget'
require_relative 'signal/signal_bool'

module Tgui
  class RadioButton < ClickableWidget

    class Theme < Widget::Theme
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

    api_attr :format do
      :to_s
    end
    
    abi_attr :checked?
    abi_attr :text, String
    abi_attr :text_clickable?
    abi_signal :on_check, Signal
    abi_signal :on_uncheck, Signal
    abi_signal :on_change, SignalBool

    def object
      self_object
    end

    def object=(object)
      self.self_object = object
      self.text = object.then(&format)
    end

    api_attr :self_object do
      nil
    end
  end
end