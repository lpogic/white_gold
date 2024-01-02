require_relative 'clickable_widget'
require_relative 'scrollbar'

module Tgui
  class Label < ClickableWidget

    class Theme < Widget::Theme
      theme_attr :borders, :outline
      theme_attr :padding, :outline
      theme_attr :text_color, :color
      theme_attr :background_color, :color
      theme_attr :border_color, :color
      theme_attr :text_style, :text_styles
      theme_attr :text_outline_color, :color
      theme_attr :text_outline_thickness, :float
      theme_attr :texture_background, :texture
      theme_comp :scrollbar, Scrollbar::Theme
      theme_attr :scrollbar_width, :float
    end

    abi_attr :text, String
    abi_attr :scrollbar_value, Integer
    abi_attr :auto_size?, Boolean, :get_
    abi_attr :max_width, Integer, :maximum_text_width
    abi_def :ignore_mouse_events, Boolean => nil
    abi_def :ignore_mouse_events?, :ignoring_mouse_events, nil => Boolean
    abi_enum "HorizontalAlignment", :left, :center, :right
    abi_attr :horizontal_alignment, HorizontalAlignment
    abi_enum "VerticalAlignment", :top, :center, :bottom
    abi_attr :vertical_alignment, VerticalAlignment
    abi_enum Scrollbar::Policy
    abi_attr :scrollbar_policy, Scrollbar::Policy
    
  end
end