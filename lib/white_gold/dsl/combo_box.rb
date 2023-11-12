require_relative 'widget'
require_relative 'signal/signal_item'
require_relative '../convention/widget_like'

module Tgui
  class ComboBox < Widget

    class SignalItem < Tgui::SignalItem
      def block_caller &b
        Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP]) do |str1, str2|
          id = str2.parse('char32_t')
          b.(@widget.self_get_object_by_id(id))
        end
      end
    end

    api_attr :self_objects do
      {}
    end
    api_attr :format do
      :to_s
    end

    abi_attr :display_count, :items_to_display
    abi_attr :default_text
    abi_attr :scroll_item?, :change_item_on_scroll
    abi_signal :on_item_select, SignalItem

    ExpandDirection = enum :down, :up, :auto

    @@auto_item_id = "@/"

    class Item < WidgetLike
      def initialize combo_box, id
        @combo_box = combo_box
        @id = id
      end

      def object=(object)
        @combo_box.self_objects[@id] = object
      end

      def object
        return @combo_box.self_objects[@id]
      end

      def text=(text)
        @combo_box._abi_change_item_by_id @id, text
      end

      def text
        @combo_box._abi_get_item_by_id @id
      end

      def selected=(selected)
        if selected
          @combo_box.selected = object
        else
          @combo_box.deselect if selected?
        end
      end

      def selected?
        @combo_box.selected == object
      end

    end

    def item object, **na, &b
      text = object.then(&format)
      @@auto_item_id = id = @@auto_item_id.next
      _abi_add_item text, id
      item = Item.new self, id
      self_objects[id] = object
      bang_nest item, **na, &b
    end

    def selected
      return self_objects[_abi_get_selected_item_id]
    end

    def selected=(object)
      id = self_find_id_by_object object
      raise "`#{object}` is out of the combobox" if !id
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

    def remove_all
      self_objects.clear
      _abi_remove_all_items
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

    def expand_direction=(direction)
      _abi_set_expand_direction ExpandDirection[direction]
    end

    def expand_direction
      ExpandDirection[_abi_get_expand_direction]
    end

    def displayed_count=(count)
      self.items_to_display = count
    end

    def displayed_count
      self.items_to_display
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