require_relative 'button_base'

module Tgui
  class ToggleButton < ButtonBase

    abi_attr :down?
    abi_signal :on_toggle

  end
end