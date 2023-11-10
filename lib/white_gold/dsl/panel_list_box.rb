require_relative 'scrollable_panel'
require_relative '../convention/widget_like'
require_relative 'signal/signal_panel_list_box_item'

module Tgui
  class PanelListBox < ScrollablePanel

    class SignalPanelListBoxItem < Tgui::SignalPanelListBoxItem
      def block_caller &b
        Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_VOIDP]) do |id|
          b.(@widget.self_objects.key(id.parse('char32_t')), @widget)
        end
      end
    end

    @@auto_item_id = "@/"
    api_attr :self_objects do
      {}
    end

    def item object, index: -1, **na, &b
      @@auto_item_id = id = @@auto_item_id.next
      panel = Panel.new pointer: _abi_add_item(id, index)
      panel.page = page
      self_objects[object] = id
      bang_nest panel, **na, &b
    end

    def [](object)
      Panel.new(pointer: _abi_get_item_by_id(self_objects[object])).tap do |panel|
        panel.page = page
      end
    end

    abi_alias :item_width, :get_items_width
    
    def item_height=(height)
      h = self_nominate_height height
      _abi_set_items_height h
    end
    abi_alias :item_height, :get_items_height

    def selected=(object)
      _abi_set_selected_item_by_id(self_objects[object])
    end

    def selected
      id = _abi_get_selected_item_id
      id == "" ? nil : self_objects.key(id)
    end

    abi_alias :deselect, :deselect_item

    def remove object
      _abi_remove_item_by_id self_objects[object]
      self_objects.delete object
    end

    def remove_all
      _abi_remove_all_items
      self_objects.clear
    end

    abi_attr :max_items, :maximum_items

    abi_signal :on_item_select, SignalPanelListBoxItem

    def template **na, &b
      panel = Panel.new(pointer: _abi_get_panel_template)
      panel.page = page
      bang_nest panel, **na, &b
    end

    def self_nominate_height height
      case height
      when Numeric then Unit.nominate height
      else height
      end
    end

  end
end