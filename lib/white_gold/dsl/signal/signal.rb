require_relative '../../abi/extern_object'

module Tgui
  class Signal < ExternObject

    def initialize pointer, widget
      super(pointer:, autofree: false)
      @widget = widget
    end

    def block_caller &b
      Fiddle::Closure::BlockCaller.new(0, [0]) do
        @widget.host! do
          b.(@widget)
        end
      end
    end

    def connect &b
      block_caller = self.block_caller &b
      id = _abi_connect(block_caller)
      @@callback_storage[id] = block_caller
      return id
    end

    def disconnect id
      success = _abi_disconnect(id)
      @@callback_storage.delete(id) if success
      return success
    end

    abi_attr :enabled?

    def suppress
      enabled_before = enabled?
      self.enabled = false
      if block_given?
        yield
        self.enabled = true
      end
    end
    
  end
end