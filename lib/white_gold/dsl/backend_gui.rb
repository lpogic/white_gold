require_relative '../extern_object'

module Tgui
  class BackendGui < ExternObject

    @@auto_name = "@/"

    def get name
      widget = _abi_get_widget name.to_s
      return nil if widget.null?
      type = Widget.get_type widget
      Tgui.const_get(type).new pointer: widget
    end

    def view
      view = nil
      block_caller = Fiddle::Closure::BlockCaller.new(0, 
        [Fiddle::TYPE_FLOAT, Fiddle::TYPE_FLOAT, Fiddle::TYPE_FLOAT, Fiddle::TYPE_FLOAT]
      ) do |*a|
        view = a
      end
      _abi_get_view block_caller
      view
    end
  end
end