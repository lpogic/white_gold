require_relative '../convention/widget_like'
require_relative 'panel'
require_relative 'scrollbar'

module Tgui
  class ScrollablePanel < Panel

    class Theme < Panel::Theme

      theme_comp :scrollbar, Tgui::Scrollbar::Theme
      theme_attr :scrollbar_width, :float
      
    end

    abi_attr :content_size, Vector2f
    abi_def :content_offset, :get_, nil => Vector2f
    abi_def :scrollbar_width, :get_, nil => Float
    abi_enum Tgui::Scrollbar::Policy

    class Scrollbar < WidgetLike
      
      def policy=(policy)
        host.send("_abi_set_#{id}_scrollbar_policy", host.abi_pack(Tgui::Scrollbar::Policy, policy))
      end

      def policy
        host.abi_unpack(Tgui::Scrollbar::Policy, host.send("_abi_get_#{id}_scrollbar_policy"))
      end

      def amount=(amount)
        host.send("_abi_set_#{id}_scroll_amount", host.abi_pack_integer(amount))
      end

      def amount
        host.abi_unpack_integer(host.send("_abi_get_#{id}_scroll_amount"))
      end

      def value=(value)
        host.send("_abi_set_#{id}_scrollbar_value", host.abi_pack_integer(value))
      end

      def value
        host.abi_unpack_integer(host.send("_abi_get_#{id}_scrollbar_value"))
      end

      def shown?
        host.abi_unpack_bool(host.send("_abi_is_#{id}_scrollbar_shown"))
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