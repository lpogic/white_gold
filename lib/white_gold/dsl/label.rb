require_relative 'clickable_widget'

module Tgui
  class Label < ClickableWidget

    abi_attr :text
    abi_attr :scrollbar_value
    abi_attr :auto_size?, :get_
    abi_attr :max_width, :maximum_text_width
    abi_alias :ignore_mouse_events
    abi_alias :ignore_mouse_events?, :ignoring_mouse_events

    HorizontalAlignment = enum :left, :center, :right

    def horizontal_alignment=(ali)
      _abi_set_horizontal_alignment HorizontalAlignment[ali]
    end

    def horizontal_alignment
      HorizontalAlignment[_abi_get_horizontal_alignment]
    end

    VerticalAlignment = enum :top, :center, :bottom

    def vertical_alignment=(ali)
      _abi_set_vertical_alignment VerticalAlignment[ali]
    end

    def vertical_alignment
      VerticalAlignment[_abi_get_vertical_alignment]
    end

    def scrollbar_policy=(policy)
      _abi_set_scrollbar_policy Scrollbar::Policy[policy]
    end

    def scorllbar_policy
      Scrollbar::Policy[_abi_get_scrollbar_policy]
    end
  end
end