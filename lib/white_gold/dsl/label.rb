require_relative 'clickable_widget'

class Tgui
  class Label < ClickableWidget
    HorizontalAlignment = enum :left, :center, :right

    def horizontal_alignment=(ali)
      Private.set_horizontal_alignment(@pointer, HorizontalAlignment[ali])
    end

    def horizontal_alignment
      HorizontalAlignment[Private.get_horizontal_alignment @pointer]
    end

    VerticalAlignment = enum :top, :center, :bottom

    def vertical_alignment=(ali)
      Private.set_vertical_alignment(@pointer, VerticalAlignment[ali])
    end

    def vertical_alignment
      VerticalAlignment[Private.get_vertical_alignment @pointer]
    end

    Policies = enum :auto, :always, :never

    def scrollbar_policy=(policy)
      Private.set_scrollbar_policy(@pointer, Policies[policy])
    end

    def scorllbar_policy
      Policies[Private.get_scrollbar_policy @pointer]
    end
  end
end