require_relative 'widget'
require_relative '../convention/widget_like'
require_relative 'signal/signal_int'

module Tgui
  class ListView < Widget

    class ListViewItemSignal < Tgui::SignalInt
      def block_caller &b
        Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_INT]) do |index|
          p index
          b.(@widget.self_objects[index], @widget)
        end
      end
    end

    class ListViewColumnSignal < Tgui::SignalInt
      def block_caller &b
        Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_INT]) do |index|
          b.(@widget.columns[index], @widget)
        end
      end
    end

    ColumnAlignment = enum :left, :center, :right

    api_attr :columns do
      []
    end
    api_attr :self_objects do
      []
    end

    class Column < WidgetLike
      def initialize list_view, index
        @list_view = list_view
        @index = index
        @format = :to_s
      end

      attr_accessor :format

      def text=(text)
        @list_view._abi_set_column_text @index, text
      end

      def text
        @list_view._abi_get_column_text @index
      end

      def width=(width)
        @list_view._abi_set_column_width @index, width
      end

      def width
        @list_view._abi_get_column_width @index
      end

      def design_width
        @list_view._abi_get_column_design_width @index
      end

      def auto_resize=(auto_resize)
        @list_view._abi_set_column_auto_resize @index, auto_resize
      end

      def auto_resize?
        @list_view._abi_get_column_auto_resize @index
      end

      def expanded=(expanded)
        @list_view._abi_set_column_expanded @index, expanded
      end

      def expanded?
        @list_view._abi_get_column_expanded @index
      end

      def alignment=(alignment)
        @list_view._abi_set_column_alignment(@index, ColumnAlignment[alignment])
      end

      def alignment
        ColumnAlignment[@list_view._abi_get_column_alignment @index]
      end
    end

    class Item < WidgetLike
      def initialize list_view, object
        @list_view = list_view
        @object = object
      end

      def index
        @list_view.self_object_index @object
      end

      def object=(object)
        @list_view.self_change_object @object, object
        @object = object
      end

      def object
        @object
      end

      def icon=(icon)
        @list_view._abi_set_item_icon index, Texture.produce(icon)
      end

      def icon
        @list_view._abi_get_item_icon index
      end
    end

    def column **na, &b
      index = _abi_add_column
      column = Column.new self, index
      columns << column
      bang_nest column, **na, &b
    end

    def item object, **na, &b
      self_add_object object, na[:index]
      item = Item.new self, object
      na.delete :index
      bang_nest item, **na, &b
    end

    def items=(items)
      remove_all_rows
      items.each do |item|
        self.item item
      end
    end

    def items
      self_objects.map(&:object)
    end

    def [](object)
      key = self_objects.index object
      key ? Item.new(self, object) : nil
    end

    def remove_columns
      self.columns = []
      _abi_remove_all_columns
    end

    def remove object
      key = self_objects.index object
      if key
        _abi_remove_item key
        self_objects.delete_at key
      end
    end

    def remove_rows
      self.self_objects = []
      _abi_remove_all_items
    end

    def selected
      if multi_select?
        self_selected_item_indices.map{ self_objects[_1] }
      else
        self_selected_item_indices.first&.tap{ self_objects[_1] }
      end
    end

    def selected=(selected)
      index = self_objects.index selected
      if index
        self_set_selected_item_indices [index]
      elsif selected.is_a? Enumerable
        self_set_selected_item_indices selected.map{|s| self_objects.index s }.compact
      end
    end

    abi_attr :separator_width
    abi_attr :row_height, :item_height
    abi_alias :deselect, :deselect_items
    abi_attr :multi_select?
    abi_attr :auto_scroll?
    abi_attr :resizable_columns?

    def vertical_scrollbar_policy=(policy)
      _abi_set_vertical_scrollbar_policy Scrollbar::Policy[policy]
    end

    def vertical_scrollbar_policy
      Scrollbar::Policy[_abi_get_vertical_scrollbar_policy]
    end

    def horizontal_scrollbar_policy=(policy)
      _abi_set_horizontal_scrollbar_policy Scrollbar::Policy[policy]
    end

    def horizontal_scrollbar_policy
      Scrollbar::Policy[_abi_get_horizontal_scrollbar_policy]
    end

    abi_attr :vertical_scrollbar_value
    abi_attr :horizontal_scrollbar_value
    abi_alias :fixed_icon_size=, :set_

    def fixed_icon_size
      size = _abi_get_fixed_icon_size
      [size.x, size.y]
    end

    abi_signal :on_item_select, ListViewItemSignal
    abi_signal :on_double_click, ListViewItemSignal
    abi_signal :on_right_click, ListViewItemSignal
    abi_signal :on_header_click, ListViewColumnSignal
    
    def grid_lines **na, &b
      lines = GridLines.new self
      bang_nest lines, **na, &b
    end

    def grid_lines=(grid_lines)
      case grid_lines
      when Numeric
        self.grid_lines width: grid_lines
      when false
        self.grid_lines horizontal: false, vertical: false
      when Hash
        self.grid_lines **grid_lines
      end
    end

    class GridLines < WidgetLike
      def initialize list_view
        @list_view = list_view
      end

      def width=(width)
        @list_view._abi_set_grid_lines_width width
      end

      def width
        @list_view._abi_get_grid_lines_width
      end

      def horizontal=(show)
        @list_view._abi_set_show_horizontal_grid_lines show
      end

      def horizontal?
        @list_view._abi_get_show_horizontal_grid_lines
      end

      def vertical=(show)
        @list_view._abi_set_show_vertical_grid_lines show
      end

      def vertical?
        @list_view._abi_get_show_vertical_grid_lines
      end
    end

    def header **na, &b
      header = Header.new self
      bang_nest header, **na, &b
    end

    def header=(header)
      case header
      when true, false
        self.header visible: header
      when Hash
        self.header **header
      when Proc
        self.header &header
      end
    end

    class Header < WidgetLike
      def initialize list_view
        @list_view = list_view
      end

      def height=(height)
        @list_view._abi_set_header_height height
      end

      def height
        @list_view._abi_get_header_height
      end

      def text_size=(size)
        @list_view._abi_set_header_text_size size
      end

      def text_size
        @list_view._abi_get_header_text_size
      end

      def separator_height=(height)
        @list_view._abi_set_header_separator_height height
      end

      def separator_height
        @list_view._abi_get_header_separator_height
      end

      def actual_height
        @list_view._abi_get_current_header_height
      end

      def visible=(show)
        @list_view._abi_set_header_visible show
      end

      def visible?
        @list_view._abi_get_header_visible
      end
    end

    def self_add_object object, index = nil
      index = self_add_item self_object_to_strings(object), index: index
      self_objects.insert index, object
      index
    end

    def self_change_object old, new
      index = self_objects.index old
      self_change_item index, self_object_to_strings(new)
      self_objects[index] = new
    end

    def self_object_to_strings object
      columns.map{|c| object.then(&c.format).to_s }
    end

    def self_add_item item, index: nil
      it = item.each
      block_caller = Fiddle::Closure::BlockCaller.new(Fiddle::TYPE_CONST_STRING, [0]) do
        it.next
      rescue StopIteration
        ""
      end
      if index
        _abi_insert_item index, block_caller
        index
      else
        _abi_add_item block_caller
      end
    end

    def self_change_item index, item
      it = item.each
      block_caller = Fiddle::Closure::BlockCaller.new(Fiddle::TYPE_CONST_STRING, [0]) do
        it.next
      rescue StopIteration
        ""
      end
      _abi_change_item index, block_caller
    end

    def self_selected_item_indices
      indices = []
      block_caller = Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_INT]) do |index|
        indices << index
      end
      _abi_get_selected_item_indices block_caller
      return indices      
    end

    def self_set_selected_item_indices indices
      it = indices.each
      block_caller = Fiddle::Closure::BlockCaller.new(Fiddle::TYPE_INT, [0]) do
        it.next
      rescue StopIteration
        -1
      end
      _abi_set_selected_items block_caller
    end
  end
end