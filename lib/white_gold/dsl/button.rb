require_relative 'button_base'
require_relative 'signal/signal'

module Tgui
  class Button < ButtonBase

    abi_signal :on_press, Signal
    
  end
end
