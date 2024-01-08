require_relative 'widget'
require_relative 'list_box'
require_relative 'signal/signal_item'
require_relative '../convention/widget_like'

module Tgui
  class ComboBox < Widget

    class Theme < Widget::Theme
      theme_attr :borders, :outline
      theme_attr :padding, :outline
      theme_attr :text_style, :text_styles
      theme_attr :default_text_style, :text_styles
      theme_attr :background_color, :color
      theme_attr :background_color_disabled, :color
      theme_attr :text_color, :color
      theme_attr :text_color_disabled, :color
      theme_attr :default_text_color, :color
      theme_attr :arrow_background_color, :color
      theme_attr :arrow_background_color_disabled, :color
      theme_attr :arrow_background_color_hover, :color
      theme_attr :arrow_color, :color
      theme_attr :arrow_color_hover, :color
      theme_attr :arrow_color_disabled, :color
      theme_attr :texture_background, :texture
      theme_attr :texture_background_disabled, :texture
      theme_attr :border_color, :color
      theme_attr :texture_background, :texture
      theme_attr :texture_background_disabled, :texture
      theme_attr :texture_arrow, :texture
      theme_attr :texture_arrow_hover, :texture
      theme_attr :texture_arrow_disabled, :texture
      theme_comp :list_box, ListBox::Theme
    end

    class SignalItem < Tgui::SignalItem
      def block_caller &b
        Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP]) do |str1, str2|
          id = @widget.abi_unpack_string(str2)
          @widget.send! do
            b.(@widget.self_get_object_by_id(id), @widget)
          end
        end
      end
    end

    api_attr :format do
      :to_s
    end

    abi_attr :display_count, Integer, :items_to_display
    abi_attr :default_text, String
    abi_attr :scroll_item?, Boolean, :change_item_on_scroll
    abi_signal :on_item_select, SignalItem

    abi_enum "ExpandDirection", :down, :up, :auto

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
        @combo_box._abi_change_item_by_id abi_pack_string(@id), abi_pack_string(text)
      end

      def text
        abi_unpack_string(@combo_box._abi_get_item_by_id abi_pack_string(@id))
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

    def! :item do |object, **na, &b|
      text = object.then(&format)
      @@auto_item_id = id = @@auto_item_id.next
      _abi_add_item abi_pack_string(text), abi_pack_string(id)
      item = Item.new self, id
      self_objects[id] = object
      item.send! **na, &b
    end

    def selected
      return self_objects[abi_unpack_string _abi_get_selected_item_id]
    end

    def selected=(object)
      id = self_find_id_by_object object
      raise "`#{object}` is out of the combobox" if !id
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

    abi_attr :expand_direction, ExpandDirection

    def [](object)
      id = self_find_id_by_object object
      id ? Item.new(self, id) : nil
    end

    # internal

    api_attr :self_objects do
      {}
    end

    def self_get_object_by_id id
      return self_objects[id]
    end

    def self_find_id_by_object object
      self_objects.find{ _2 == object }&.at(0)
    end
    
  end
end