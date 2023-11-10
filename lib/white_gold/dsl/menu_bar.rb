require_relative 'widget'
require_relative '../convention/widget_like'
require_relative 'signal/signal_item_hierarchy'

module Tgui
  class MenuBar < Widget

    class ItemPressSignal
      def initialize menu_bar, path
        @menu_bar = menu_bar
        @path = path
      end

      def connect &b
        on_press = Fiddle::Closure::BlockCaller.new(0, [0]) do
          b.(@path.last, @path, @menu_bar)
        end

        return @menu_bar.self_path_block @path do
          id = @menu_bar._abi_connect_menu_item _1, _2, on_press
          MenuBar.callback_storage[id] = _2
          id
        end
      end
  
      def disconnect id
        @menu_bar.on_menu_item_click.disconnect id
      end
    end

    class SignalItemHierarchy < Tgui::SignalItemHierarchy

      def block_caller &b
        Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_VOIDP]) do |vector|
          path = []
          loader = Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_VOIDP]) do |str|
            path << str.parse('char32_t')
          end
          SignalItemHierarchy.fetch_path vector, loader
          object_path = @widget.self_object_path path
          b.(object_path.last, object_path, @widget)
        end
      end
    end

    class TreeNode
      def initialize text
        @text = text
        @nodes = {}
      end

      attr_accessor :text
      attr :nodes

      def [](*path, grow: false)
        if grow
          path.reduce(self){|node, o| node.nodes[o] ||= TreeNode.new(nil) }
        else
          path.reduce(self){|node, o| node&.nodes[o] }
        end
      end

      def cut *path, last
        self[*path].nodes.delete last
      end

      def cut_branches *path
        self[*path].nodes = {}
      end

      def path_str_to_object *path
        object_path = []
        path.reduce self do |node, str|
          o, node = *node.nodes.find{|k, v| v.text == str }
          object_path << o
          node
        end
        object_path
      end

      def path_object_to_str *path
        str_path = []
        path.reduce self do |node, o|
          node[o].tap{ str_path << _1.text }
        end
        str_path
      end
    end

    api_attr :self_tree do
      TreeNode.new nil
    end
    api_attr :format do
      :to_s
    end

    class MenuItem < WidgetLike
      def item object, **na, &b
        item_path = [*path, object]
        @menu_bar.self_tree[*item_path, grow: true].text = object.then(&@menu_bar.format)
        @menu_bar.self_path_block item_path do
          @menu_bar._abi_add_menu_item _1, _2
        end
        item = Item.new @menu_bar, item_path
        bang_nest item, **na, &b
      end
      
      def on_press(&b)
        signal = ItemPressSignal.new @menu_bar, path
        block_given? ? signal.connect(&b) : signal
      end

      def on_press=(b)
        on_press &b
      end

      def remove_subitems
        @menu_bar.self_path_block path do
          @menu_bar._abi_remove_sub_menu_item _1, _2
          @menu_bar.self_tree.cut_branches *_3
        end
      end

      def text=(text)
        @menu_bar.self_path_block path do
          @menu_bar._abi_change_menu_item _1, _2, text
          @menu_bar.self_tree[*path].text = text
        end
      end

      def text
        @menu_bar.self_tree[*path].text
      end

      def [](*path)
        Item.new(@menu_bar, self.path + path)
      end
    end

    class Menu < MenuItem
      def initialize menu_bar, object
        @menu_bar = menu_bar
        @object = object
      end

      def enabled=(enabled)
        @menu_bar._abi_set_menu_enabled text, enabled
      end

      def enabled?
        @menu_bar._abi_get_menu_enabled text
      end

      def remove
        @menu_bar._abi_remove_menu @menu_bar.self_tree[@object].text
      end

      def path
        [@object]
      end
    end

    class Item < MenuItem
      def initialize menu_bar, path
        @menu_bar = menu_bar
        @path = path.freeze
      end

      def enabled=(enabled)
        @menu_bar.self_path_block path do
          @menu_bar._abi_set_menu_item_enabled _1, _2, enabled
        end   
      end

      def enabled?
        @menu_bar.self_path_block path do
          @menu_bar._abi_get_menu_item_enabled _1, _2
        end
      end

      def remove
        @menu_bar.self_path_block path do
          @menu_bar._abi_remove_menu_item _1, _2
          @menu_bar.self_tree.cut *_3
        end
      end

      def path
        @path
      end
    end

    def item object, **na, &b
      text = object.then(&format)
      self_tree[object, grow: true].text = text
      _abi_add_menu text
      item = Menu.new self, object
      bang_nest item, **na, &b
    end

    def items=(items)
      self_make_items items
    end

    def items
      self_collect_items(self_tree)
    end

    def [](*path)
      case path.size
      when 0 then self
      when 1 then Menu.new(self, path[0])
      else Item.new(self, path)
      end
    end

    abi_attr :min_item_width, :minimum_sub_menu_width
    abi_alias :direction_inverted=, :set_inverted_menu_direction
    abi_alias :direction_inverted?, :get_inverted_menu_direction
    abi_alias :close, :close_menu
    abi_alias :remove_all

    def remove *path
      self[*path].remove
    end

    abi_signal :on_item_click, SignalItemHierarchy, :on_menu_item_click

    def self_path_block path, &b
      path = self_tree.path_object_to_str *path
      it = path.each
      block_caller = Fiddle::Closure::BlockCaller.new(Fiddle::TYPE_CONST_STRING, [0]) do
        it.next
      end
      b.(path.size, block_caller, path)
    end

    def self_object_path path
      self_tree.path_str_to_object *path
    end

    def self_collect_items tree_node
      tree_node.nodes.map{|k, v| [k, self_collect_items(v)]}.to_h
    end

    def self_make_items items, path = []
      items.each do |k, v|
        item = self[*path].item k
        case v
        when Hash
          self_make_items v, [*path, k]
        when Proc
          item.on_press &v
        when String
          item.text = v
        end
      end
    end
  end
end