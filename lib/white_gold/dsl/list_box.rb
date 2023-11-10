require_relative 'widget'
require_relative 'signal/signal_item'
require_relative 'signal/signal_u_int'

module Tgui
  class ListBox < Widget

    class SignalItem < Tgui::SignalItem
      def block_caller &b
        Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP]) do |str1, str2|
          id = str2.parse('char32_t')
          b.(@widget.self_get_object_by_id(id))
        end
      end
    end

    TextAlignment = enum :left, :center, :right

    @@auto_item_id = "@/"

    api_attr :self_objects do
      Hash.new
    end
    abi_attr :item_height
    abi_attr :max_items, :maximum_items
    abi_attr :auto_scroll?
    abi_attr :scrollbar_value
    abi_signal :on_item_select, SignalItem
    abi_signal :on_mouse_press, SignalItem
    abi_signal :on_mouse_release, SignalItem
    abi_signal :on_double_click, SignalItem
    abi_signal :on_scroll, SignalUInt

    def text_alignment=(alignment)
      _abi_set_text_alignment TextAlignment[alignment]
    end

    def text_alignment
      TextAlignment[_abi_get_text_alignment]
    end

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
        @list_box._abi_change_item_by_id @id, text
      end

      def remove
        @list_box._abi_remove_item_by_id @id
      end
    end

    def item object = nil, **na, &b
      @@auto_item_id = id = @@auto_item_id.next
      _abi_add_item object.to_s, id
      item = Item.new self, id
      na[:object] ||= object
      bang_nest item, **na, &b
    end

    def remove_all
      self_objects.clear
      _abi_remove_all_items
    end

    def selected
      return self_objects[_abi_get_selected_item_id]
    end

    def selected=(object)
      id = self_find_id_by_object object
      raise "`#{object}` is out of the listbox" if !id
      _abi_set_selected_item_by_id id
    end

    abi_alias :deselect, :deselect_item

    def remove object
      id = self_find_id_by_object object
      if id
        _abi_remove_item_by_id id
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

    def self_get_object_by_id id
      return self_objects[id]
    end

    def self_find_id_by_object object
      self_objects.find{ _2 == object }&.at(0)
    end
  end
end