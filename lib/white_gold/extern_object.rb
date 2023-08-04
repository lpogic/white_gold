class Tgui
  class ExternObject  
    def initialize pointer:, autofree: true
      @pointer = pointer
      
      if autofree
        cl = self.class
        while !cl.respond_to?(:finalizer)
          cl = cl.superclass
        end
        ObjectSpace.define_finalizer(self, cl.finalizer(pointer))
      end
    end

    attr :pointer

    def self.finalizer pointer
      proc do
        Util.free(pointer)
      end
    end

    @@callback_storage = {}

    def self.callback_storage=(callback_storage)
      @@callback_storage = callback_storage
    end
  end
end