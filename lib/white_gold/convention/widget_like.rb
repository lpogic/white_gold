require_relative 'api_def'
require_relative 'bang_nest'

class WidgetLike
  extend ApiDef
  include BangNest

  class << self
    def abi_def name, original_name = nil, id: false, **na
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
      if id
        interface = na.map do |k, v|
          k = self_packers_id_extend id, *k
          Interface.from k, v 
        end.first
        if name.to_s.end_with? "="
          self_abi_def_setter_with_id name, abi_name, interface, id
        else
          self_abi_def_with_id name, abi_name, interface, id
        end
      else
        interface = na.map do |k, v|
          Interface.from k, v 
        end.first
        if name.to_s.end_with? "="
          self_abi_def_setter name, abi_name, interface
        else
          self_abi_def name, abi_name, interface
        end
      end
    end

    def self_packers_id_extend id_position, *packers
      [*packers[0..id_position], Object, *packers[id_position..]]
    end

    def self_abi_def name, abi_name, abi_interface
      define_method name do |*a|
        abi_interface.call host, abi_name, *a
      end
    end

    def self_abi_def_with_id name, abi_name, abi_interface, id_position
      define_method name do |*a|
        abi_interface.call host, abi_name, *a[0..id_position], id, *a[id_position..]
      end
    end

    def self_abi_def_setter name, abi_name, abi_interface
      define_method name do |a = VOID|
        abi_interface.call host, abi_name, *a
      end
    end

    def self_abi_def_setter_with_id name, abi_name, abi_interface, id_position
      define_method name do |a = VOID|
        abi_interface.call host, abi_name, *a[0..id_position], id, *a[id_position..]
      end
    end

    def abi_attr name, type = nil, original_name = nil, id: false
      if original_name
        if original_name.end_with? "_"
          getter = "_abi_#{original_name}#{name}".delete_suffix("?").to_sym
          setter = "_abi_set_#{name}".delete_suffix("?").to_sym
        else
          getter = "_abi_get_#{original_name}".to_sym
          setter = "_abi_set_#{original_name}".to_sym
        end
      else
        if name.end_with? "?"
          getter = "_abi_is_#{name}".delete_suffix("?").to_sym
        else 
          getter = "_abi_get_#{name}".to_sym
        end
        setter = "_abi_set_#{name}".delete_suffix("?").to_sym
      end
      type ||= "Boolean" if name.end_with? "?"
      abi_def "#{name.to_s.delete_suffix("?")}=".to_sym, setter, id: id, type => nil
      abi_def name, getter, id: id, nil => type
    end

    def abi_enum base, *keys, **indexed_keywords
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

    def abi_bit_enum name, zero, *keywords, **indexed_keywords
      if base.is_a? Enum
        enum = base
      else
        enum = Enum.new zero, **(keywords.each_with_index.map{[_1, 1 << _2]}.to_h), **indexed_keywords
        const_set base, enum
        enum.name = base
      end
      abi_packer enum do |o|
        enum.pack(o)
      end
      abi_unpacker enum do |o|
        enum.unpack(o)
      end
    end
  end

  def initialize host, id
    @host = host
    @id = id
  end

  attr :host
  attr :id

  def flags=(flags)
    flags.each do |f|
      send("#{f}=", true)
    end
  end
end