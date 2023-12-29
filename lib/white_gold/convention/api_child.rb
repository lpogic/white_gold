module Tgui
  module ApiChild
    API_CHILD_PREFIX = "api_child_".freeze

    def api_child name, original_name = nil, &b
      if block_given?
        define_method "#{API_CHILD_PREFIX}#{name}", &b
      else
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
        define_method "#{API_CHILD_PREFIX}#{name}" do |*a|
          send(abi_name, *a)
        end
      end
    end
  end
end