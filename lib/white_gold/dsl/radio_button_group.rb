require_relative 'container'

module Tgui
  class RadioButtonGroup < Container

    abi_def :uncheck, :uncheck_radio_buttons
    abi_def :checked_radio_button, :get_, nil => Widget

    def checked
      checked_radio_button&.object
    end
    
  end
end