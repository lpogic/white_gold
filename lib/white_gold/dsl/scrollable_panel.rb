require_relative '../convention/widget_like'
require_relative 'panel'
require_relative 'scrollbar'

module Tgui
  class ScrollablePanel < Panel

    abi_alias :content_size=, :set_

    def content_size
      v = _abi_get_content_size
      [v.x, v.y]
    end

    abi_alias :content_offset, :get_
    abi_alias :scrollbar_width, :get_

    class Scrollbar < WidgetLike
      def initialize scrollable_panel, direction
        @scrollable_panel = scrollable_panel
        @direction = direction
      end

      def policy=(policy)
        @scrollable_panel.send("_abi_set_#{@direction}_scrollbar_policy", Tgui::Scrollbar::Policy[policy])
      end

      def policy
        Tgui::Scrollbar::Policy[@scrollable_panel.send("_abi_get_#{@direction}_scrollbar_policy")]
      end

      def amount=(amount)
        @scrollable_panel.send("_abi_set_#{@direction}_scroll_amount", amount)
      end

      def amount
        @scrollable_panel.send("_abi_get_#{@direction}_scroll_amount")
      end

      def value=(value)
        @scrollable_panel.send("_abi_set_#{@direction}_scrollbar_value", value)
      end

      def value
        @scrollable_panel.send("_abi_get_#{@direction}_scrollbar_value")
      end

      def shown?
        @scrollable_panel.send("_abi_is_#{@direction}_scrollbar_shown")
      end
    end

    def horizontal_scrollbar
      Scrollbar.new self, :horizontal
    end
    
    def vertical_scrollbar
      Scrollbar.new self, :vertical
    end

  end
end