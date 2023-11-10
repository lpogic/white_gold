module Tgui
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

    def initialized
    end

    attr :pointer

    def self.finalizer pointer
      proc do
        Util.free(pointer)
      end
    end

    @@callback_storage = {}
    @@data_storage = {}

    def self.callback_storage=(callback_storage)
      @@callback_storage = callback_storage
    end

    def self.callback_storage
      @@callback_storage
    end

    def self.data_storage=(data_storage)
      @@data_storage = data_storage
    end

    def self.abi_alias name, original_name = nil
      if original_name
        if original_name.end_with? "_"
          abi_name = "_abi_#{original_name}#{name}".delete_suffix("?").to_sym
        else
          abi_name = "_abi_#{original_name}".to_sym
        end
      else
        abi_name = "_abi_#{name}".delete_suffix("?").to_sym
      end
      define_method name do |*a|
        send(abi_name, *a)
      end
    end

    def self.abi_attr name, original_name = nil
      if original_name
        if original_name.end_with? "_"
          abi_getter = "_abi_#{original_name}#{name}".delete_suffix("?").to_sym
        else
          abi_getter = "_abi_get_#{original_name}".to_sym
        end
      else
        if name.end_with? "?"
          abi_getter = "_abi_is_#{name}".delete_suffix("?").to_sym
        else 
          abi_getter = "_abi_get_#{name}".to_sym
        end
      end
      define_method name do |*a|
        send(abi_getter, *a)
      end
      if original_name
        if original_name.end_with? "_"
          abi_setter = "_abi_set_#{name}".delete_suffix("?").to_sym
        else
          abi_setter = "_abi_set_#{original_name}".to_sym
        end
      else
        abi_setter = "_abi_set_#{name}".delete_suffix("?").to_sym
      end
      api_setter = "#{name.to_s.delete_suffix("?")}=".to_sym
      define_method api_setter do |a|
        send(abi_setter, *a)
      end
    end

    def self.abi_signal name, signal_class = Signal, original_name = nil
      abi_getter = "_abi_#{original_name || name}".to_sym
      define_method name do |*a, &b|
        signal_pointer = send(abi_getter, *a)
        signal = signal_class.new signal_pointer, self
        b ? signal.connect(&b) : signal
      end
      define_method "#{name}=" do |a|
        send(name, &a)
      end
    end 
  end
end