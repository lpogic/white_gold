require_relative 'clickable_widget'

module Tgui
  class ProgressBar < ClickableWidget
    FillDirection = enum :left_to_right, :right_to_left, :top_to_bottom, :bottom_to_top

    def fill_direction=(direction)
      _abi_set_fill_direction(@pointer, FillDirection[direction])
    end

    alias_method :fill_direction!, :fill_direction=

    def fill_direction
      FillDirection[_abi_get_fill_direction @pointer]
    end
  end
end