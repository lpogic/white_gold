require_relative 'clickable_widget'

module Tgui
  class Label < ClickableWidget
    HorizontalAlignment = enum :left, :center, :right

    def horizontal_alignment=(ali)
      _abi_set_horizontal_alignment(@pointer, HorizontalAlignment[ali])
    end

    def horizontal_alignment
      HorizontalAlignment[_abi_get_horizontal_alignment @pointer]
    end

    VerticalAlignment = enum :top, :center, :bottom

    def vertical_alignment=(ali)
      _abi_set_vertical_alignment(@pointer, VerticalAlignment[ali])
    end

    def vertical_alignment
      VerticalAlignment[_abi_get_vertical_alignment @pointer]
    end

    Policies = enum :auto, :always, :never

    def scrollbar_policy=(policy)
      _abi_set_scrollbar_policy(@pointer, Policies[policy])
    end

    def scorllbar_policy
      Policies[_abi_get_scrollbar_policy @pointer]
    end
  end
end