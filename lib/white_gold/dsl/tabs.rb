require_relative 'widget'
require_relative '../convention/widget_like'
require_relative 'signal/signal'

module Tgui
  class Tabs < Widget

    class Tab < WidgetLike
      def initialize tabs, index
        @tabs = tabs
        @index = index
      end

      def text=(text)
        @tabs.change_text @index, text
      end

      def text
        @tabs.text @index
      end
      
      def visible=(visible)
        @tabs._abi_set_tab_visible @index, visible
      end

      def visible?
        @tabs._abi_get_tab_visible @index
      end

      def enabled=(enabled)
        @tabs._abi_set_tab_enabled @index, enabled
      end

      def enabled?
        @tabs._abi_get_tab_enabled @index
      end

    end

    api_attr :objects do
      []
    end
    api_attr :format do
      :to_s
    end

    abi_attr :auto_size?
    abi_alias :deselect
    abi_alias :tab_height=, :set_
    abi_attr :max_tab_width, :maximum_tab_width
    abi_attr :min_tab_width, :minimum_tab_width

    def tab object, index: nil, **na, &b
      text = object.then(&format)
      if !index
        index = _abi_add text, false
      else
        _abi_insert index, text, false
      end
      objects.insert index, object
      tab = Tab.new self, index
      bang_nest tab, **na, &b
    end

    def remove object
      index = objects.index object
      if index && _abi_remove(index)
        objects.delete_at index
      end
    end

    def remove_all
      _abi_remove_all
      self.objects = []
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

    def [](object)
      index = objects.index object
      index ? Tab.new(self, index) : nil
    end

    def items
      objects
    end

    class SignalTabSelect < Signal

      def block_caller &b
        Fiddle::Closure::BlockCaller.new(0, [0]) do
          b.(@widget.selected, @widget)
        end
      end

    end

    abi_signal :on_tab_select, SignalTabSelect
  end
end