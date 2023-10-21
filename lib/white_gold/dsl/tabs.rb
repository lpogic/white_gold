require_relative 'widget'

module Tgui
  class Tabs < Widget
    class Tab
      def initialize tabs, index
        @tabs = tabs
        @index = index
      end

      def text=(text)
        tabs.change_text @index, text
      end

      def text
        tabs.text @index
      end

      def selected=(selected)
        if selected
          tabs.select_by_index @index
        else
          tabs.deselect if tabs.selected_index == @index
        end
      end

    end

    def tab text:, index: nil, **na, &b
      if !index
        index = add text, false
      else
        insert index, text, false
      end
      tab = Tab.new self, index
      bang_nest tab, **na, &b
    end

    class Tabs
      def initialize tabs
        @tabs = tabs
      end

      def [](index)
        case index
        when Integer
          Tab.new @tabs, index
        when :selected
          selected_index = @tabs.selected_index
          selected_index >= 0 ? Tab.new(@tabs, selected_index) : nil
        else
          raise ArgumentError("Only Integers or :selected allowed")
        end
      end
    end

    def tabs
      Tabs.new self
    end
  end
end