require_relative 'clickable_widget'

class Tgui
  class ButtonBase < ClickableWidget
    def text_position=(text_position)
      position, origin = *text_position
      Private.set_text_position(@pointer, "(#{position[0]},#{position[1]})", "(#{origin[0]},#{origin[1]})")
    end
  end
end