require_relative '../extern_object'

class Tgui
  class Widget < ExternObject

    def respond_to? name
      super || name.start_with?("_")
    end

    def method_missing name, *a, **na, &b
      if name.start_with? "_"
        if name.end_with? "="
          @@data_storage[Widget.get_unshared(@pointer).to_i][name[...-1]] = a[0]
        else
          @@data_storage[Widget.get_unshared(@pointer).to_i][name.to_s]
        end
      else
        super
      end
    end
  end
end