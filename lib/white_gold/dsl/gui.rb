require_relative 'backend_gui'
require_relative 'signal/signal'

module Tgui
  class Gui < BackendGui

    def self.finalizer(pointer)
      _abi_delete pointer
    end

    abi_def :self_add, :add, [Object, String] => nil
    abi_def :self_remove, :remove, [Object] => nil
    abi_def :self_active?, :is_active, nil => Boolean
    abi_def :self_poll_events, :poll_events
    abi_def :self_draw, :draw
    abi_def :background_color=, :set_clear_color, Color => nil
    abi_attr :clipboard, String
    abi_def :screen_size, :get_, nil => Vector2i

    attr_accessor :page

    def! :messagebox do |*a, **na, &b|
      messagebox = MessageBox.new
      @page.send! :add, messagebox
      @page.scope! messagebox, *a, **na, &b
    end
        
  end
end