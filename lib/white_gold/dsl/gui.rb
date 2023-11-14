require_relative 'backend_gui'
require_relative 'signal/signal'

module Tgui
  class Gui < BackendGui

    abi_alias :self_add, :add
    abi_alias :self_remove, :remove
    abi_alias :self_active?, :is_active
    abi_alias :self_poll_events, :poll_events
    abi_alias :self_draw, :draw
    
    def clear_color=(color)
      c = Color.produce color
      _abi_set_clear_color c
    end

    abi_attr :clipboard
    
  end
end