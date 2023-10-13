require_relative '../extern_object'

class Tgui
  class Signal < ExternObject

    def connect &b
      block_caller = Fiddle::Closure::BlockCaller.new(0, [0], &b)
      id = Private.connect(@pointer, block_caller)
      @@callback_storage[id] = block_caller
      return id
    end

    def disconnect id
      success = Private.disconnect(@pointer, id)
      @@callback_storage.delete(id) if success
      return success
    end
  end
end