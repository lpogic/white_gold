require_relative '../abi/extern_object'

module Tgui
  class Font < ExternObject

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
    
  end
end