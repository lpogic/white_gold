require_relative 'backend_gui'
require_relative 'signal/signal'

module Tgui
  class Gui < BackendGui

    abi_def :self_add, :add, [Object, String] => nil
    abi_def :self_remove, :remove, [Object] => nil
    abi_def :self_active?, :is_active, nil => Boolean
    abi_def :self_poll_events, :poll_events
    abi_def :self_draw, :draw
    abi_def :clear_color=, Color => nil
    abi_attr :clipboard, String
        
  end
end