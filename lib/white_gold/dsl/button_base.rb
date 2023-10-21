require_relative 'clickable_widget'

module Tgui
  class ButtonBase < ClickableWidget

    abi_attr :text
    
    def text_position=(text_position)
      position, origin = *text_position
      _abi_set_text_position(@pointer, "(#{position[0]},#{position[1]})", "(#{origin[0]},#{origin[1]})")
    end
  end
end