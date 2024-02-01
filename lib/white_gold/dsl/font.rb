require_relative '../abi/extern_object'

module Tgui
  class Font < ExternObject

    def self.finalizer pointer
      _abi_delete pointer
    end

    def self.from *arg
      case arg.size
      when 1
        a = arg.first
        case a
        when Font
          return a
        when String
          id = Util.expand_path a
        else raise "Unsupported argument #{arg}"
        end
      else raise "Unsupported argument #{arg}"
      end
      Font.new id
    end

    def self.default
      Font.new pointer: _abi_get_global_font
    end

  end
end