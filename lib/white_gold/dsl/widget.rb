require_relative '../extern_object'
require_relative '../convention/bang_nested_caller'

class Tgui
  class Widget < ExternObject
    include BangNestedCaller

    def respond_to? name
      super || name.start_with?("_") || bang_respond_to?(name)
    end

    def method_missing name, *a, **na, &b
      if name.start_with? "_"
        if name.end_with? "="
          @@data_storage[Widget.get_unshared(@pointer).to_i][name[...-1]] = a[0]
        else
          @@data_storage[Widget.get_unshared(@pointer).to_i][name.to_s]
        end
      else
        bang_method_missing name, *a, **na, &b
      end
    end
  end
end