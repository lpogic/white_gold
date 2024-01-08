require_relative 'widget'
require_relative 'scrollbar'
require_relative '../convention/widget_like'

module Tgui
  class ChatBox < Widget

    class Theme < Widget::Theme
      theme_attr :borders, :outline
      theme_attr :padding, :outline
      theme_attr :background_color, :color
      theme_attr :border_color, :color
      theme_attr :texture_background, :texture
      theme_comp :scrollbar, Scrollbar::Theme
      theme_attr :scrollbar_width, :float
    end

    api_attr :objects do
      []
    end
    api_attr :format do
      :to_s
    end

    class Line < WidgetLike
      def initialize chat_box, index
        @chat_box = chat_box
        @index = index
      end

      def color
        @chat_box._abi_get_line_color abi_pack_integer(@index)
      end

      def style
        abi_unpack_text_styles(@chat_box._abi_get_line_style abi_pack_integer(@index))
      end
    end

    def! :line do |object, color: nil, style: nil, **na, &b|
      text = object.then(&format)
      color ||= text_color
      style ||= text_style
      _abi_add_line abi_pack_string(text), abi_pack(Color, color), abi_pack(TextStyles, *style)
      line = Line.new self, objects.size
      objects << object
      line.send! **na, &b
    end

    def [](index)
      index = objects.index object
      index ? Line.new(self, index) : nil
    end

    def remove object
      index = objects.index object
      if index
        _abi_remove_line abi_pack_integer(index)
        objects.delete_at index
      end
    end

    def remove_all
      _abi_remove_all_lines
      objects.clear
    end

    abi_attr :line_limit, Integer
    abi_attr :text_color, Color
    abi_attr :text_style, TextStyles
    abi_attr :lines_start_from_top?
    abi_attr :new_lines_below_others?
    abi_attr :scrollbar_value, Integer

  end
end
