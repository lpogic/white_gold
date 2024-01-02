require_relative 'clickable_widget'
require_relative 'signal/signal_string'
require_relative 'signal/signal_typed_size_t'

module Tgui
  class EditBox < ClickableWidget

    class Theme < Widget::Theme
      theme_attr :text_style, :text_styles
      theme_attr :default_text_style, :text_styles
      theme_attr :borders, :outline
      theme_attr :padding, :outline
      theme_attr :caret_width, :float
      theme_attr :text_color, :color
      theme_attr :text_color_disabled, :color
      theme_attr :text_color_focused, :color
      theme_attr :selected_text_color, :color
      theme_attr :selected_text_background_color, :color
      theme_attr :default_text_color, :color
      theme_attr :background_color, :color
      theme_attr :background_color_hover, :color
      theme_attr :background_color_disabled, :color
      theme_attr :background_color_focused, :color
      theme_attr :caret_color, :color
      theme_attr :caret_color_hover, :color
      theme_attr :caret_color_focused, :color
      theme_attr :border_color, :color
      theme_attr :border_color_hover, :color
      theme_attr :border_color_disabled, :color
      theme_attr :border_color_focused, :color
      theme_attr :texture, :texture
      theme_attr :texture_hover, :texture
      theme_attr :texture_disabled, :texture
      theme_attr :texture_focused, :texture
    end

    def abi_pack_integer_range *a
      if a.size == 1
        if a[0].is_a? Range
          return [abi_pack_integer(o.min), abi_pack_integer(o.max - o.min)]
        end
      elsif a.size == 2
        return o.map{ abi_pack_integer _1 }
      end
      raise "Unable to pack #{a} to IntegerRange"
    end

    abi_enum "Alignment", :left, :center, :right
    abi_attr :default_text, String
    abi_def :select_text, "IntegerRange" => nil
    abi_def :selected_text, :get_, nil => String
    abi_attr :password_character, String
    abi_attr :characters_limit, Integer, :maximum_characters
    abi_def :limited_text_width=, :limit_text_width, Boolean => nil
    abi_def :limited_text_width?, :is_text_width_limited, nil => Boolean
    abi_attr :read_only?
    abi_attr :caret_position, Integer
    abi_attr :suffix, String
    abi_signal :on_text_change, SignalString
    abi_signal :on_return_key_press, SignalString
    abi_signal :on_return_or_unfocus, SignalString
    abi_signal :on_caret_position_change, SignalTypedSizeT
    abi_attr :text, String
    abi_attr :alignment, Alignment
    
  end
end