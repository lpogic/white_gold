require_relative 'signal'

module Tgui
  class GlobalSignal < Signal


    def block_caller &b
      Fiddle::Closure::BlockCaller.new(0, [0]) do
        @widget.host! do
          b.(@widget)
        end
      end
    end

    def block_caller &b
      Fiddle::Closure::BlockCaller.new(0, [0], &b)
    end

    def connect &b
      @block_caller = self.block_caller &b
      id = _abi_connect(@block_caller)
      @@global_callback_storage[id] = self
      return id
    end

    def disconnect id
      success = _abi_disconnect(id)
      @@global_callback_storage.delete(id) if success
      return success
    end
    
  end
end