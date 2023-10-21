require_relative 'button_base'

module Tgui
  class Button < ButtonBase

    abi_signal :on_press, Signal
    
  end
end
