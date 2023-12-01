module Alias
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

    interface = na.map{|k, v| Interface.from k, v }.first
    self_abi_def name, abi_name, interface
  end

  def self_abi_def name, abi_name, abi_interface
    define_method name do |*a|
      abi_interface.call self, abi_name, *a
    end
  end

  def abi_attr name, type = nil, original_name = nil
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
    abi_def "#{name.to_s.delete_suffix("?")}=".to_sym, setter, type => nil
    abi_def name, getter, nil => type
  end
end