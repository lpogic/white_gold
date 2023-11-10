require_relative 'widget'
require_relative 'signal/signal_item_hierarchy'

module Tgui
  class TreeView < Widget

    class SignalItemHierarchy < Tgui::SignalItemHierarchy
      def block_caller &b
        Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_VOIDP]) do |vector|
          path = []
          loader = Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_VOIDP]) do |str|
            path << str.parse('char32_t')
          end
          SignalItemHierarchy.fetch_path vector, loader
          object_path = @widget.self_tree.path_str_to_object path
          b.(object_path.last, object_path, @widget)
        end
      end
    end

    class TreeNode
      def initialize object
        @object = object
        @nodes = {}
      end

      attr_accessor :object
      attr :nodes

      def [](*path, grow: false)
        if grow
          path.reduce(self){|node, str| node.nodes[str] ||= TreeNode.new nil }
        else
          path.reduce(self){|node, str| node&.nodes[str] }
        end
      end

      def cut *path, last
        self[*path].nodes.delete last
      end

      def path_str_to_object path
        objects = []
        path.reduce(self){|node, str| node[str].tap{|n| objects << n.object } }
        objects
      end
    end

    api_attr :self_tree do
      TreeNode.new nil
    end
    api_attr :format do
      :to_s
    end

    class Item < WidgetLike
      def initialize tree_view, path
        @tree_view = tree_view
        @path = path
      end

      attr :path

      def self_path_block &b
        @tree_view.self_path_block @path, &b
      end

      def expanded=(expanded)
        self_path_block do
          expanded ? @tree_view._abi_expand(_1, _2) : @tree_view._abi_collapse(_1, _2)
        end
      end

      def collapsed=(collapsed)
        self.expanded = !collapsed
      end

      def selected=(selected)
        if selected
          self_path_block do
            @tree_view.select_item(_1, _2)
          end
        else
          selected_item = @tree_view.selected_item
          if selected_item.path == @path
            @tree_view.deselect_item
          end
        end
      end

      def remove
        self_path_block do
          @tree_view._abi_remove_item _1, _2, false
          @tree_view.self_tree.cut *_3
        end
      end

      def item object, **na, &b
        @tree_view.self_add_item @path, object, **na, &b
      end

      def [](*path_end)
        Item.new @tree_view, [*@path, *path_end]
      end

      def object
        @path.last
      end
    end

    def item object, **na, &b
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
      path = []
      loader = Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_VOIDP]) do |str|
        path << str.parse('char32_t')
      end
      _abi_get_selected_item loader
      path.empty? ? nil : Item.new(self, self_tree.path_str_to_object(path))
    end

    def selected
      selected_item&.object
    end

    abi_alias :expand_all
    abi_alias :collapse_all
    abi_alias :deselect
    abi_alias :remove_all
    abi_attr :item_height
    abi_attr :vertical_scrollbar_value
    abi_attr :horizontal_scrollbar_value


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
        _abi_add_item _1, _2, true
        self_tree[*_3, grow: true].object = object
      end
      item = Item.new self, new_path
      bang_nest item, **na, &b
    end

    def self_path_block path, &b
      path = path.map(&format)
      it = path.each
      block_caller = Fiddle::Closure::BlockCaller.new(Fiddle::TYPE_CONST_STRING, [0]) do
        it.next
      end
      b.(path.size, block_caller, path)
    end

    abi_signal :on_item_select, SignalItemHierarchy
    abi_signal :on_double_click, SignalItemHierarchy
    abi_signal :on_expand, SignalItemHierarchy
    abi_signal :on_collapse, SignalItemHierarchy
    abi_signal :on_right_click, SignalItemHierarchy
  end
end