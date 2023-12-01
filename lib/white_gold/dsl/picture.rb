require_relative 'clickable_widget'
require_relative 'signal/signal_vector2f'

module Tgui
  class Picture < ClickableWidget

    abi_def :ignore_mouse, :ignore_mouse_events, "Boolean" => nil
    abi_def :ignore_mouse?, :is_ignoring_mouse_events, nil => "Boolean"
    abi_signal :on_double_click, SignalVector2f
    
  end
end