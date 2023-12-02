require_relative 'interface/interface'

module Packer
  def abi_packer base, &body
    if block_given?
      define_method abi_packer_method_name(base), &body
    elsif base.is_a? Module
      define_method abi_packer_method_name(base) do |*o|
        base.from *o
      end
    else
      raise "..."
    end
  end

  def abi_packer_method_name base
    case base
    when String then "abi_pack#{Interface.abi_const_string_method_suffix base}".to_sym
    when Symbol then base.to_s.start_with?("_") ? "abi_pack#{base}".to_sym : base
    else "abi_pack#{Interface.abi_const_string_method_suffix base.name}".to_sym
    end
  end

  def abi_pack host, type, *a
    Interface.parse_packer(type).call host, *a
  end
end
    