require_relative 'container'
require_relative '../convention/delegate'

module Tgui
  class TabContainer < Container

    TabAlign = enum :top, :bottom

    def tab_alignment=(alignment)
      _abi_set_tab_alignment(@pointer, TabAlign[alignment])
    end
    
    def tab_alignment
      TabAlign[_abi_get_tab_alignment @pointer]
    end

    class TabPanel < Panel

      def initialize tab_container, index, panel_pointer
        super(pointer: panel_pointer)
        @tab_container = tab_container
        @index = index
      end

      def text=(text)
        @tab_container.change_tab_text @index, text
      end

      def text
        @tab_container.tab_text @index
      end

      def selected=(selected)
        if selected
          p @index
          @tab_container.select @index
        else
          @tab_container.deselect if @tab_container.selected_index == @index
        end
      end

      def enabled=(enabled)
        tabs = Tabs.new pointer: _abi_ABI_TabContainer_getTabs(@tab_container.pointer)
        tabs.tab_enabled = [@index, enabled]
      end
    end

    def tab text:, index: nil, **na, &b
      if !index
        panel_pointer = add_tab text, false
        index = self.index panel_pointer
      else
        panel_pointer = insert_tab index, text, false
      end
      tab_panel = TabPanel.new self, index, panel_pointer
      bang_nest tab_panel, **na, &b
    end

    class TabPanels
      def initialize tab_container
        @tab_container = tab_container
      end

      def [](index)
        case index
        when Integer
          panel = @tab_container.panel index
          TabPanel.new @tab_container, index, panel
        when :selected
          selected_index = @tab_container.selected_index
          selected_index >= 0 ? self[selected_index] : nil
        else
          raise ArgumentError("Only Integers or :selected allowed")
        end
      end
    end

    def tabs
      TabPanels.new self
    end
  end
end