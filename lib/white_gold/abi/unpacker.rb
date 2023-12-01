require_relative 'interface/interface'

module Unpacker
  def abi_unpacker base, &body
    if block_given?
      define_method abi_unpacker_method_name(base), &body
    elsif base.is_a? Module
      define_method abi_unpacker_method_name(base) do |o|
        base.new pointer: o
      end
    else
      raise "..."
    end
  end

  def abi_unpacker_method_name base
    case base
    when String then "abi_unpack#{Interface.abi_const_string_method_suffix base}".to_sym
    when Symbol then base.to_s.start_with?("_") ? "abi_unpack#{base}".to_sym : base
    else "abi_unpack#{Interface.abi_const_string_method_suffix base.name}".to_sym
    end
  end

  def abi_unpack host, type, object
    Interface.parse_unpacker(type).call host, object
  end
end