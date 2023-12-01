require_relative 'widget'
require_relative 'signal/signal_item'
require_relative 'signal/signal_u_int'

module Tgui
  class ListBox < Widget

    class SignalItem < Tgui::SignalItem
      def block_caller &b
        Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP]) do |str1, str2|
          id = @widget.abi_unpack_string(str2)
          b.(@widget.self_get_object_by_id(id))
        end
      end
    end

    abi_enum "TextAlignment", :left, :center, :right

    @@auto_item_id = "@/"

    api_attr :format do
      :to_s
    end

    abi_attr :item_height, Integer
    abi_attr :max_items, Integer, :maximum_items
    abi_attr :auto_scroll?
    abi_attr :scrollbar_value, Integer
    abi_signal :on_item_select, SignalItem
    abi_signal :on_mouse_press, SignalItem
    abi_signal :on_mouse_release, SignalItem
    abi_signal :on_double_click, SignalItem
    abi_signal :on_scroll, SignalUInt
    abi_attr :text_alignment, TextAlignment

    class Item
      def initialize list_box, id
        @list_box = list_box
        @id = id
      end

      def object=(object)
        @list_box.self_objects[@id] = object
      end

      def object
        return @list_box.self_objects[@id]
      end

      def text=(text)
        @list_box._abi_change_item_by_id @id, abi_pack_string(text)
      end

      def remove
        @list_box._abi_remove_item_by_id @id
      end
    end

    def item object = nil, **na, &b
      text = object.then(&format)
      @@auto_item_id = id = @@auto_item_id.next
      _abi_add_item abi_pack_string(text), abi_pack_string(id)
      item = Item.new self, id
      na[:object] ||= object
      bang_nest item, **na, &b
    end

    def remove_all
      self_objects.clear
      _abi_remove_all_items
    end

    def selected
      return self_objects[abi_unpack_string _abi_get_selected_item_id]
    end

    def selected=(object)
      id = self_find_id_by_object object
      raise "`#{object}` is out of the listbox" if !id
      _abi_set_selected_item_by_id abi_pack_string(id)
    end

    abi_def :deselect, :deselect_item

    def remove object
      id = self_find_id_by_object object
      if id
        _abi_remove_item_by_id abi_pack_string(id)
        self_objects.delete id
      end
    end

    def items=(items)
      remove_all
      items.each do |item|
        self.item item
      end
    end
    
    def items
      self_objects.values
    end

    def [](object)
      id = self_find_id_by_object object
      id ? Item.new(self, id) : nil
    end
    
    # internal

    api_attr :self_objects do
      Hash.new
    end

    def self_get_object_by_id id
      return self_objects[id]
    end

    def self_find_id_by_object object
      self_objects.find{ _2 == object }&.at(0)
    end
  end
end