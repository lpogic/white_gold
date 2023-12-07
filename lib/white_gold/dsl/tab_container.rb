require_relative 'container'
require_relative 'tabs'

module Tgui
  class TabContainer < Container

    class Tabs < Tgui::Tabs
      def initialize tabs_container, pointer
        super(pointer:)
        @tabs_container = tabs_container
      end

      abi_enum "TabAlign", :top, :bottom


      def alignment=(alignment)
        @tabs_container._abi_set_tab_alignment @tabs_container.abi_pack(TabAlign, alignment)
      end
      
      def alignment
        @tabs_container.abi_unpack(TabAlign, @tabs_container._abi_get_tab_alignment)
      end

      def fixed_size=(size)
        @tabs_container._abi_set_fixed_size @tabs_container.abi_pack_float(size)
      end

      def fixed_size
        @tabs_container.abi_unpack_float(@tabs_container._abi_get_fixed_size)
      end

      def height=(height)
        @tabs_container._abi_set_tabs_height @tabs_container.abi_pack("Layout", h)
      end
    end

    class TabPanel < Panel

      def initialize tab_container, index, panel_pointer
        super(pointer: panel_pointer)
        @tab_container = tab_container
        @index = index
      end

      def text=(text)
        @tab_container.change_tab_text @index, @tab_container.abi_pack_string(text)
      end

      def text
        @tab_container.abi_unpack_string(@tab_container.tab_text @index)
      end
    end

    def objects
      tabs.objects
    end

    def format=(format)
      tabs.format = format
    end

    def format
      tabs.format
    end

    api_def :tab do |object, index: nil, **na, &b|
      text = object.then(&format)
      if !index
        panel_pointer = _abi_add_tab abi_pack_string(text), abi_pack_boolean(false)
        index = _abi_get_index panel_pointer
      else
        index = abi_pack_integer index
        panel_pointer = _abi_insert_tab index, abi_pack_string(text), abi_pack_boolean(false)
      end
      objects.insert index, object
      tab_panel = TabPanel.new self, index, panel_pointer
      tab_panel.page = page
      upon! tab_panel, **na, &b
    end
    
    def [](object)
      index = objects.index object
      if index
        panel_pointer = _abi_get_panel
        TabPanel.new(self, index, panel_pointer).tap do |tp|
          tp.page = page
        end
      else 
        nil
      end
    end

    api_def :tabs do |**na, &b|
      tabs = Tabs.new self, _abi_get_tabs
      tabs.page = page
      upon! tabs, **na, &b
    end

    def remove object
      index = objects.index object
      if index && _abi_remove_tab(index)
        objects.delete_at index
      end
    end

    def selected=(selected)
      index = objects.index selected
      if index
        _abi_select index
      end
    end

    def selected
      index = _abi_get_selected_index
      index >= 0 ? objects[index] : nil
    end

    abi_signal :on_selection_change, Signal
    
  end
end