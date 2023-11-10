require_relative 'container'

module Tgui
  class RadioButtonGroup < Container

    abi_alias :uncheck, :uncheck_radio_buttons

    def checked_radio_button
      self_cast_up _abi_get_checked_radio_button
    end

    def checked
      checked_radio_button&.object
    end
    
  end
end