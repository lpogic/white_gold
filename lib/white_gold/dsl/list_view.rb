require_relative 'widget'

class Tgui
  class ListView < Widget

    ColumnAlignment = enum :left, :center, :right

    def set_column_alignment(index, ali)
      Private.set_column_alignment(@pointer, index, ColumnAlignment[ali])
    end
    
    def column_alignment(index)
      ColumnAlignment[Private.get_column_alignment @pointer, index]
    end

    class Column
      def initialize list_view
        @list_view = list_view
      end

      def index
        @list_view.column_index self
      end

      def text=(text)
        @list_view.column_text = [index, text]
      end

      def text
        @list_view.column_text index
      end

      def width=(width)
        @list_view.column_width = [index, width]
      end

      def width
        @list_view.column_width index
      end

      def alignment=(alignment)
        @list_view.set_column_alignment index, alignment
      end

      def alignment
        @list_view.column_alignment index
      end
    end

    class Item
      def initialize list_view
        @list_view = list_view
      end

      def index
        @list_view.item_index self
      end

      def data=(data)
        @list_view.change_item index, *data
      end

      def data
        @list_view.item_data index
      end

      def remove
        @list_view.remove_item index
      end

      def selected?
        @list_view.selected_item_indices.include? index
      end

      def selected=(selected)
        selected_item_indices = selected ? @list_view.selected_item_indices + [index] : @list_view.selected_item_indices.except(index)
        @list_view.set_selected_item_indices selected_item_indices
      end

      def icon=(icon)
        @list_view.set_item_icon index, Texture.produce(icon)
      end

      def icon
        @list_view.item_icon index
      end
    end

    def column **na, &b
      w = Column.new self
      i = add_column
      @columns[w] = i
      na.each do |k, v|
        if w.respond_to? "#{k}="
          w.send("#{k}=", v)
        else
          send(k).send("[]=", w, v)
        end
      end
      if b
        b.call w
      end
      w
    end

    def column_index column
      @columns[column]
    end

    def remove_all_columns
      @columns = {}
      Private.remove_all_columns @pointer
    end

    def columns
      @columns.invert
    end

    def item **na, &b
      w = Item.new self
      if na[:index]
        index = na[:index]
        add_item *na[:data], index:
      else
        index = add_item *na[:data]
      end
      @items[w] = index
      na.delete(:data)
      na.each do |k, v|
        if w.respond_to? "#{k}="
          w.send("#{k}=", v)
        else
          send(k).send("[]=", w, v)
        end
      end
      if b
        b.call w
      end
      w
    end

    class Items

      def initialize list_view, items
        @list_view = list_view
        @items = items
      end

      def [](selector)
        case selector
        when Integer
          @items[selector]
        when :selected
          @list_view.selected_item_indices.map{ @items[_1] }
        end
      end
    end

    def items
      Items.new self, @items.invert
    end

    def item_index item
      @items[item]
    end

    def remove_item index
      Private.remove_item @pointer, index
      @items.filter!{ _2 != index }.transform_values!{ _1 > index ? _1 - 1 : _1 }
    end

    def remove_all_items
      @items = {}
      Private.remove_all_items @pointer
    end

    def initialized
      super
      @columns = {}
      @items = {}
    end

    def add_item *values, index: nil
      it = values.each
      block_caller = Fiddle::Closure::BlockCaller.new(Fiddle::TYPE_CONST_STRING, [0]) do
        it.next
      rescue StopIteration
        ""
      end
      if index
        Private.insert_item @pointer, index, block_caller
      else
        Private.add_item @pointer, block_caller
      end
    end

    def change_item index, *values
      it = values.each
      block_caller = Fiddle::Closure::BlockCaller.new(Fiddle::TYPE_CONST_STRING, [0]) do
        it.next
      rescue StopIteration
        ""
      end
      Private.change_item @pointer, index, block_caller
    end

    def item_data index
      data = []
      block_caller = Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_VOIDP]) do |str|
        data << str.parse('char32_t')
      end
      Private.get_item_row @pointer, index, block_caller
      return data
    end

    def selected_item_indices
      indices = []
      block_caller = Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_INT]) do |index|
        indices << index
      end
      Private.get_selected_item_indices @pointer, block_caller
      return indices      
    end

    def set_selected_item_indices indices
      it = indices.each
      block_caller = Fiddle::Closure::BlockCaller.new(Fiddle::TYPE_INT, [0]) do
        it.next
      rescue StopIteration
        -1
      end
      Private.set_selected_items @pointer, block_caller
    end
  end
end