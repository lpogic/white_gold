require_relative 'widget'
require_relative 'scrollbar'
require_relative '../convention/widget_like'
require_relative 'signal/signal_int'

module Tgui
  class ListView < Widget

    class Theme < Widget::Theme
      theme_attr :borders, :outline
      theme_attr :padding, :outline
      theme_attr :background_color, :color
      theme_attr :background_color_hover, :color
      theme_attr :selected_background_color, :color
      theme_attr :selected_background_color_hover, :color
      theme_attr :text_color, :color
      theme_attr :text_color_hover, :color
      theme_attr :selected_text_color, :color
      theme_attr :selected_text_color_hover, :color
      theme_attr :header_background_color, :color
      theme_attr :header_text_color, :color
      theme_attr :border_color, :color
      theme_attr :separator_color, :color
      theme_attr :grid_lines_color, :color
      theme_attr :texture_header_background, :texture
      theme_attr :texture_background, :texture
      theme_comp :scrollbar, Scrollbar::Theme
      theme_attr :scrollbar_width, :float
    end

    class ListViewItemSignal < Tgui::SignalInt
      def block_caller &b
        Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_INT]) do |index|
          @widget.send! do
            b.(@widget.self_objects[index], @widget)
          end
        end
      end
    end

    class ListViewColumnSignal < Tgui::SignalInt
      def block_caller &b
        Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_INT]) do |index|
          @widget.send! do
            b.(@widget.columns[index], @widget)
          end
        end
      end
    end

    abi_enum "ColumnAlignment", :left, :center, :right

    api_attr :columns do
      []
    end

    class Column < WidgetLike
      def initialize list_view, index
        super
        @format = :to_s
      end

      attr_accessor :format

      abi_attr :text, String, :column_text, id: 0
      abi_attr :width, Integer, :column_width, id: 0
      abi_def :design_width, :get_column_, id: 0, nil => Integer
      abi_attr :auto_resize?, Boolean, :column_auto_resize, id: 0
      abi_attr :expanded?, Boolean, :column_expanded, id: 0
      abi_attr :alignment, ColumnAlignment, :column_alignment, id: 0
    end

    class Item < WidgetLike
      def initialize list_view, object
        super
      end

      def id
        host.self_object_index @id
      end

      def object=(object)
        @list_view.self_change_object @id, object
        self.id = object
      end

      alias_method :object, :id

      abi_attr :icon, Texture, :item_icon, id: 0
    end

    def! :column do |**na, &b|
      index = _abi_add_column
      column = Column.new self, index
      columns << column
      column.send! **na, &b
    end

    def! :item do |object, **na, &b|
      self_add_object object, na[:index]
      item = Item.new self, object
      na.delete :index
      item.send! **na, &b
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

    abi_attr :separator_width, Integer
    abi_attr :row_height, Integer, :item_height
    abi_def :deselect, :deselect_items
    abi_attr :multi_select?
    abi_attr :auto_scroll?
    abi_attr :resizable_columns?
    abi_enum Scrollbar::Policy
    abi_attr :vertical_scrollbar_policy, Scrollbar::Policy
    abi_attr :horizontal_scrollbar_policy, Scrollbar::Policy
    abi_attr :vertical_scrollbar_value, Integer
    abi_attr :horizontal_scrollbar_value, Integer
    abi_attr :fixed_icon_size, Vector2f
    abi_signal :on_item_select, ListViewItemSignal
    abi_signal :on_double_click, ListViewItemSignal
    abi_signal :on_right_click, ListViewItemSignal
    abi_signal :on_header_click, ListViewColumnSignal
    
    def! :grid_lines do | **na, &b|
      lines = GridLines.new self
      lines.send! **na, &b
    end

    def grid_lines=(grid_lines)
      case grid_lines
      when Numeric
        api_bang_grid_lines width: grid_lines
      when false
        api_bang_grid_lines horizontal: false, vertical: false
      when Hash
        api_bang_grid_lines **grid_lines
      end
    end

    class GridLines < WidgetLike
      def initialize list_view
        super(list_view, nil)
      end

      abi_attr :width, Integer, :grid_lines_width
      abi_attr :horizontal?, Boolean, :show_horizontal_grid_lines
      abi_attr :vertical?, Boolean, :show_vertical_grid_lines
    end

    def! :header do |**na, &b|
      header = Header.new self
      header.send! **na, &b
    end

    def header=(header)
      case header
      when true, false
        api_bang_header visible: header
      when Hash
        api_bang_header **header
      when Proc
        api_bang_header &header
      end
    end

    class Header < WidgetLike
      def initialize list_view
        super(list_view, nil)
      end

      abi_attr :height, Integer, :header_height
      abi_attr :text_size, Integer, :header_text_size
      abi_attr :separator_height, Integer, :header_separator_height
      abi_def :actual_height, :get_current_header_height, nil => Integer
      abi_attr :visible, Boolean, :header_visible
    end

    # internal

    api_attr :self_objects do
      []
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
      if index
        _abi_insert_item index, abi_pack(String..., item)
        index
      else
        _abi_add_item abi_pack(String..., *item)
      end
    end

    abi_def :self_change_item, :change_item, [Integer, String...] => nil
    abi_attr :self_selected_item_indices, Integer.., :selected_item_indices
  end
end