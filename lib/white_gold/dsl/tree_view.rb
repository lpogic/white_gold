require_relative 'widget'
require_relative '../convention/tree_node'
require_relative 'signal/signal_item_hierarchy'

module Tgui
  class TreeView < Widget

    class Theme < Widget::Theme
      theme_attr :borders, :outline
      theme_attr :padding, :outline
      theme_attr :background_color, :color
      theme_attr :background_color_hover, :color
      theme_attr :selected_background_color, :color
      theme_attr :selected_background_color_hover, :color
      theme_attr :border_color, :color
      theme_attr :text_color, :color
      theme_attr :text_color_hover, :color
      theme_attr :selected_text_color, :color
      theme_attr :selected_text_color_hover, :color
      theme_comp :scrollbar, Scrollbar::Theme
      theme_attr :scrollbar_width, :float
      theme_attr :texture_background, :texture
      theme_attr :texture_branch_expanded, :texture
      theme_attr :texture_branch_collapsed, :texture
      theme_attr :texture_leaf, :texture
    end

    class SignalItemHierarchy < Tgui::SignalItemHierarchy
      def block_caller &b
        Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_VOIDP]) do |vector|
          path = []
          loader = Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_VOIDP]) do |str|
            path << @widget.abi_unpack_string(str)
          end
          SignalItemHierarchy.fetch_path vector, loader
          object_path = @widget.self_tree.path_str_to_object *path
          @widget.host! do
            b.(object_path.last, object_path, @widget)
          end
        end
      end
    end

    api_attr :self_tree do
      TreeNode.new nil
    end
    api_attr :format do
      :to_s
    end

    class Item < WidgetLike

      alias_method :path, :id

      def self_path_block &b
        host.self_path_block path, &b
      end

      def expanded=(expanded)
        self_path_block do
          expanded ? host._abi_expand(_1, _2) : host._abi_collapse(_1, _2)
        end
      end

      def collapsed=(collapsed)
        self.expanded = !collapsed
      end

      def selected=(selected)
        if selected
          self_path_block do
            host.select_item(_1, _2)
          end
        else
          selected_item = host.selected_item
          if selected_item.path == path
            host.deselect_item
          end
        end
      end

      def remove
        self_path_block do
          host._abi_remove_item _1, _2, abi_pack_boolean(false)
          host.self_tree.cut *_3
        end
      end

      def! :item do |object, **na, &b|
        host.self_add_item path, object, **na, &b
      end

      def [](*path_end)
        Item.new host, [*path, *path_end]
      end

      def text=(text)
        host.self_change_item path, text
      end

      def text
        host.self_tree[*path].text
      end

      def object
        path.last
      end
    end

    def! :item do |object, **na, &b|
      self_add_item [], object, **na, &b
    end

    def items=(items)
      self_items items
    end

    def items
      self_collect_items self_tree
    end

    def [](*path)
      Item.new self, path
    end

    def remove *path
      self[*path].remove
    end

    def selected=(path)
      self[*path].selected = true
    end

    def selected_item
      path = self_selected_item_path
      path.empty? ? nil : Item.new(self, self_tree.path_str_to_object(path))
    end

    def selected
      selected_item&.object
    end

    abi_def :expand_all
    abi_def :collapse_all
    abi_def :deselect
    abi_def :remove_all
    abi_attr :item_height, Integer
    abi_attr :vertical_scrollbar_value, Integer
    abi_attr :horizontal_scrollbar_value, Integer
    abi_signal :on_item_select, SignalItemHierarchy
    abi_signal :on_double_click, SignalItemHierarchy
    abi_signal :on_expand, SignalItemHierarchy
    abi_signal :on_collapse, SignalItemHierarchy
    abi_signal :on_right_click, SignalItemHierarchy

    # internal

    abi_def :self_selected_item_path, :get_selected_item, nil => (String..)

    def self_items items, path = []
      items.each do |k, v|
        self_add_item path, k
        self_items v, [*path, k] if v.is_a? Hash
      end
    end

    def self_collect_items tree_node
      tree_node.nodes.map{|k, v| [v.object, self_collect_items(v)]}.to_h
    end


    def self_add_item path, object, **na, &b
      new_path = [*path, object]
      self_path_block new_path do
        _abi_add_item _1, _2, abi_pack_boolean(true)
        self_tree[*new_path, grow: true].text = _3
      end
      item = Item.new self, new_path
      scope! item, **na, &b
    end

    def self_change_item path, text, **na, &b
      self_path_block path do
        _abi_change_item _1, _2, text
        self_tree[*path].text = text
      end
    end

    def self_path_block path, &b
      path = path.map(&format)
      b.(*abi_pack(String.., *path), path.last)
    end
  end
end