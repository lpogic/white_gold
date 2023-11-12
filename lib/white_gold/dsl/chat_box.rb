require_relative 'widget'
require_relative '../convention/widget_like'

module Tgui
  class ChatBox < Widget

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
        @chat_box._abi_get_line_color @index
      end

      def style
        TextStyles.unpack(@chat_box._abi_get_line_style @index)
      end
    end

    def line object, color: nil, style: nil, **na, &b
      text = object.then(&format)
      color ||= text_color
      style ||= text_style
      _abi_add_line text, Color.produce(color), TextStyles.pack(*style)
      line = Line.new self, objects.size
      objects << object
      bang_nest line, **na, &b
    end

    def [](index)
      index = objects.index object
      index ? Line.new(self, index) : nil
    end

    def remove object
      index = objects.index object
      if index
        _abi_remove_line index
        objects.delete_at index
      end
    end

    def remove_all
      _abi_remove_all_lines
      objects.clear
    end

    abi_attr :line_limit

    def text_color=(color)
      c = Color.produce(color)
      _abi_set_text_color c
    end

    abi_alias :text_color, :get_

    def text_style=(style)
      _abi_set_text_style TextStyles.pack(*style)
    end

    def text_style
      TextStyles.unpack(_abi_get_text_style)
    end

    abi_attr :lines_start_from_top?
    abi_attr :new_lines_below_others?
    abi_attr :scrollbar_value

    
  end
end
