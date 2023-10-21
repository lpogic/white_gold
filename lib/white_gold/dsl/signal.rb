require_relative '../extern_object'

module Tgui
  class Signal < ExternObject

    def initialize pointer, widget
      super(pointer:, autofree: false)
      @widget = widget
    end

    def block_caller &b
      Fiddle::Closure::BlockCaller.new(0, [0], &b)
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
  end
end