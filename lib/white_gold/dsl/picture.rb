require_relative 'clickable_widget'
require_relative 'signal/signal_vector2f'

module Tgui
  class Picture < ClickableWidget

    abi_alias :ignore_mouse, :ignore_mouse_events
    abi_alias :ignore_mouse?, :is_ignoring_mouse_events

    abi_signal :on_double_click, SignalVector2f
  end
end