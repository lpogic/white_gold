require_relative '../extern_object'

module Tgui
  class Font < ExternObject
    def self.produce arg
      case arg
      when Font
        return arg
      when String
        id = Util.expand_path arg
      else
        raise "Unsupported argument #{arg}"
      end
      Font.new id
    end
  end
end