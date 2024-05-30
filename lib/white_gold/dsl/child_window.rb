require_relative 'container'
require_relative 'button'
require_relative 'signal/signal'

module Tgui
  class ChildWindow < Container

    class Theme < Widget::Theme
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
      theme_comp :close_button, Button::Theme
      theme_comp :maximize_button, Button::Theme
      theme_comp :minimize_button, Button::Theme
    end

    class SignalClosing < Tgui::Signal
      def block_caller &b
        Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_VOIDP]) do |ptr|
          @widget.host! do
            b.(ptr, @widget)
          end
        end
      end
    end

    abi_enum "TitleAlignment", :left, :center, :right
    abi_bit_enum "TitleButtons", :none, :close, :maximize, :minimize, all: -1

    abi_attr :client_size, "SizeLayout"
    abi_attr :max_size, Vector2f, :maximum_size
    abi_attr :min_size, Vector2f, :minimum_size
    abi_attr :title, String
    abi_attr :title_size, Integer, :title_text_size
    abi_attr :title_alignment, TitleAlignment
    abi_attr :title_buttons, TitleButtons
    abi_attr :resizable?
    abi_attr :position_locked?
    abi_attr :keep_in_parent?, Boolean, :get_

    def close destroy = false
      if destroy
        _abi_destroy
      else
        _abi_close
      end
    end

    abi_signal :on_mouse_press, Signal
    abi_signal :on_close, Signal
    abi_signal :on_maximize, Signal
    abi_signal :on_minimize, Signal
    abi_signal :on_escape_press, Signal
    abi_signal :on_closing, SignalClosing
    
  end
end