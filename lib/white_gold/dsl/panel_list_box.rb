require_relative 'scrollable_panel'
require_relative '../convention/widget_like'
require_relative 'signal/signal_panel_list_box_item'

module Tgui
  class PanelListBox < ScrollablePanel

    class Theme < ScrollablePanel::Theme

      theme_attr :items_background_color, :color
      theme_attr :items_background_color_hover, :color
      theme_attr :selected_items_background_color, :color
      theme_attr :selected_items_background_color_hover, :color

    end

    class SignalPanelListBoxItem < Tgui::SignalPanelListBoxItem
      def block_caller &b
        Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_VOIDP]) do |id|
          @widget.send! do
            b.(@widget.self_objects.key(@widget.abi_unpack_string(id)), @widget)
          end
        end
      end
    end

    @@auto_item_id = "@/"

    def! :item do |object, index: -1, **na, &b|
      @@auto_item_id = id = @@auto_item_id.next
      panel = Panel.new pointer: _abi_add_item(id, abi_pack_integer(index))
      panel.page = page
      self_objects[object] = id
      panel.send! **na, &b
    end

    def [](object)
      Panel.new(pointer: _abi_get_item_by_id(self_objects[object])).tap do |panel|
        panel.page = page
      end
    end

    abi_def :item_width, :get_items_width, nil => Float
    abi_packer "NominatedFloat" do |value|
      case value
      when Numeric then Unit.nominate value
      else value
      end
    end
    abi_unpacker "NominatedFloat" do |o|
      abi_unpack_float o
    end
    abi_attr :item_height, "NominatedFloat", :items_height

    def selected=(object)
      _abi_set_selected_item_by_id self_objects[object]
    end

    def selected
      id = abi_unpack_string(_abi_get_selected_item_id)
      id == "" ? nil : self_objects.key(id)
    end

    abi_def :deselect, :deselect_item

    def remove object
      _abi_remove_item_by_id self_objects[object]
      self_objects.delete object
    end

    def remove_all
      _abi_remove_all_items
      self_objects.clear
    end

    abi_attr :max_items, Integer, :maximum_items

    abi_signal :on_item_select, SignalPanelListBoxItem

    def! :template do |**na, &b|
      panel = Panel.new(pointer: _abi_get_panel_template)
      panel.page = page
      panel.send! **na, &b
    end

    # internal

    api_attr :self_objects do
      {}
    end
  end
end