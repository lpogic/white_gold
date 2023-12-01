require_relative 'clickable_widget'
require_relative 'signal/signal_bool'

module Tgui
  class RadioButton < ClickableWidget
    
    abi_attr :checked?
    abi_attr :text, String
    abi_attr :text_clickable?
    abi_signal :on_check, Signal
    abi_signal :on_uncheck, Signal
    abi_signal :on_change, SignalBoolean
    api_attr :object do
      nil
    end
    
  end
end