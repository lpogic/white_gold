require_relative '../convention/bang_def'
require_relative 'packer'
require_relative 'unpacker'

class ExternObject
  extend Packer
  extend Unpacker
  extend BangDef

  def initialize pointer:, autofree: true
    @pointer = pointer
    
    if autofree
      cl = self.class
      while !cl.respond_to?(:finalizer)
        cl = cl.superclass
      end
      ObjectSpace.define_finalizer(self, cl.proc.finalizer(pointer))
    end
    initialized
  end

  def initialized
  end

  attr :pointer

  @@callback_storage = {}
  @@global_callback_storage = {}
  @@data_storage = {}

  def abi_pack type, *a
    ExternObject.abi_pack self, type, *a
  end

  def abi_unpack type, object
    ExternObject.abi_unpack self, type, object
  end

  class << self

    def callback_storage=(callback_storage)
      @@callback_storage = callback_storage
    end

    def callback_storage
      @@callback_storage
    end

    def global_callback_storage=(global_callback_storage)
      @@global_callback_storage = global_callback_storage
    end

    def global_callback_storage
      @@global_callback_storage
    end

    def data_storage=(data_storage)
      @@data_storage = data_storage
    end

    def abi_def name, original_name = nil, **na
      if original_name
        if original_name.end_with? "_"
          abi_name = "_abi_#{original_name}#{name}".delete_suffix("=").delete_suffix("?").to_sym
        else
          abi_name = "_abi_#{original_name}".to_sym
        end
      else
        if name.end_with? "?"
          abi_name = "_abi_is_#{name}".delete_suffix("?").to_sym
        elsif name.end_with? "="
          abi_name = "_abi_set_#{name}".delete_suffix("=").to_sym
        else
          abi_name = "_abi_#{name}".to_sym
        end
      end

      na = {nil => nil} if na.empty?
      interface = na.map{|k, v| Interface.from k, v }.first
      if name.to_s.end_with? "="
        self_abi_def_setter name, abi_name, interface
      else
        self_abi_def name, abi_name, interface
      end
    end

    def self_abi_def name, abi_name, abi_interface, *def_attr
      define_method name do |*a|
        abi_interface.call self, abi_name, *def_attr, *a
      end
    end

    def self_abi_def_setter name, abi_name, abi_interface, *def_attr
      define_method name do |a = VOID|
        abi_interface.call self, abi_name, *def_attr, *a
      end
    end

    def abi_attr name, type = nil, original_name = nil
      if original_name
        if original_name.end_with? "_"
          getter = "#{original_name}#{name}".delete_suffix("?").to_sym
          setter = "set_#{name}".delete_suffix("?").to_sym
        else
          if name.end_with? "?"
            getter = "is_#{original_name}".to_sym
          else 
            getter = "get_#{original_name}".to_sym
          end
          setter = "set_#{original_name}".to_sym
        end
      else
        if name.end_with? "?"
          getter = "is_#{name}".delete_suffix("?").to_sym
        else 
          getter = "get_#{name}".to_sym
        end
        setter = "set_#{name}".delete_suffix("?").to_sym
      end
      type ||= Boolean if name.end_with? "?"
      abi_def "#{name.to_s.delete_suffix("?")}=".to_sym, setter, type => nil
      abi_def name, getter, nil => type
    end

    def abi_enum base, *keywords, **indexed_keywords
      if base.is_a? Enum
        enum = base
      else
        enum = Enum.new *keywords, **indexed_keywords
        const_set base, enum
        enum.name = base
      end
      abi_packer enum do |o|
        enum.sym_to_i(o)
      end
      abi_unpacker enum do |o|
        enum.i_to_sym(o)
      end
    end

    def abi_bit_enum base, zero, *keywords, **indexed_keywords
      if base.is_a? Enum
        enum = base
      else
        enum = Enum.new zero, **(keywords.each_with_index.map{[_1, 1 << _2]}.to_h), **indexed_keywords
        const_set base, enum
        enum.name = base
      end
      abi_packer enum do |*o|
        enum.pack(*o)
      end
      abi_unpacker enum do |o|
        enum.unpack(o)
      end
    end

    def abi_signal name, signal_class = Signal, original_name = nil
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

    def abi_static name, original_name = nil
      if original_name
        if original_name.end_with? "_"
          abi_name = "_abi_#{original_name}#{name}".delete_suffix("=").delete_suffix("?").to_sym
        else
          abi_name = "_abi_#{original_name}".delete_suffix("=").to_sym
        end
      else
        abi_name = "_abi_#{name}".delete_suffix("=").delete_suffix("?").to_sym
      end
      define_singleton_method name do |*a|
        send(abi_name, *a)
      end
    end
  end
end