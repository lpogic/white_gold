require_relative 'widget'
require_relative '../convention/tree_node'
require_relative '../convention/widget_like'
require_relative 'signal/signal_item_hierarchy'

module Tgui
  class MenuBar < Widget

    class Theme < Widget::Theme
      theme_attr :background_color, :color
      theme_attr :selected_background_color, :color
      theme_attr :text_color, :color
      theme_attr :selected_text_color, :color
      theme_attr :text_color_disabled, :color
      theme_attr :separator_color, :color
      theme_attr :texture_background, :texture
      theme_attr :texture_item_background, :texture
      theme_attr :texture_selected_item_background, :texture
      theme_attr :distance_to_side, :float
      theme_attr :separator_thickness, :float
      theme_attr :separator_vertical_padding, :float
      theme_attr :separator_side_padding, :float
    end

    class ItemPressSignal
      def initialize menu_bar, path
        @menu_bar = menu_bar
        @path = path
      end

      def connect &b
        on_press = Fiddle::Closure::BlockCaller.new(0, [0]) do
          @menu_bar.send! do
            b.(@path.last, @path, @menu_bar)
          end
        end

        return @menu_bar.self_path_block @path do
          id = @menu_bar._abi_connect_menu_item _1, _2, on_press
          MenuBar.callback_storage[id] = on_press
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
            path << @widget.abi_unpack_string(str)
          end
          SignalItemHierarchy.fetch_path vector, loader
          object_path = @widget.self_object_path path
          @widget.send! do
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

    class MenuItem < WidgetLike
      def! :item do |object, **na, &b|
        item_path = [*path, object]
        host.self_tree[*item_path, grow: true].text = object.then(&host.format)
        host.self_path_block item_path do
          host._abi_add_menu_item _1, _2
        end
        item = Item.new host, item_path
        item.send! **na, &b
      end

      def! :separator do
        item! "-"
      end
      
      def on_press(&b)
        signal = ItemPressSignal.new host, path
        block_given? ? signal.connect(&b) : signal
      end

      def on_press=(b)
        on_press &b
      end

      def remove_subitems
        host.self_path_block path do
          host._abi_remove_sub_menu_item _1, _2
          host.self_tree.cut_branches *_3
        end
      end

      def text=(text)
        host.self_path_block path do
          host._abi_change_menu_item _1, _2, text
          host.self_tree[*path].text = text
        end
      end

      def text
        host.self_tree[*path].text
      end

      def [](*path)
        Item.new(host, self.path + path)
      end
    end

    class Menu < MenuItem

      alias_method :id, :text

      abi_attr :enabled?, Boolean, :menu_enabled, id: 0
      abi_def :remove, :remove_menu, id: 0

      def path
        [@id]
      end
    end

    class Item < MenuItem
      def initialize menu_bar, path
        super(menu_bar, path.freeze)
      end


      def enabled=(enabled)
        host.self_path_block path do
          host._abi_set_menu_item_enabled _1, _2, enabled
        end   
      end

      def enabled?
        host.self_path_block path do
          host._abi_get_menu_item_enabled _1, _2
        end
      end

      def remove
        host.self_path_block path do
          host._abi_remove_menu_item _1, _2
          host.self_tree.cut *_3
        end
      end

      def path
        @id
      end
    end

    def! :item do |object, **na, &b|
      text = object.then(&format)
      self_tree[object, grow: true].text = text
      _abi_add_menu abi_pack_string(text)
      item = Menu.new self, object
      item.send! **na, &b
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

    abi_attr :min_item_width, Integer, :minimum_sub_menu_width
    abi_attr :direction_inverted?, Boolean, :inverted_menu_direction
    abi_def :close, :close_menu
    abi_def :remove_all

    def remove *path
      self[*path].remove
    end

    abi_signal :on_item_click, SignalItemHierarchy, :on_menu_item_click

    def self_path_block path, &b
      path = self_tree.path_object_to_str *path
      b.(*abi_pack(String.., *path), path)
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