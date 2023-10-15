require_relative 'widget'

class Tgui
  class Tabs < Widget
    class Item
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

    def item text:, index: nil, **na, &b
      if !index
        index = add text, false
      else
        insert index, text, false
      end
      item = Item.new self, index
      bang_nest item, **na, &b
    end

    class Items
      def initialize tabs
        @tabs = tabs
      end

      def [](index)
        case index
        when Integer
          Item.new @tabs, index
        when :selected
          selected_index = @tabs.selected_index
          selected_index >= 0 ? Item.new(@tabs, selected_index) : nil
        else
          raise ArgumentError("Only Integers or :selected allowed")
        end
      end
    end

    def items
      Items.new self
    end
  end
end