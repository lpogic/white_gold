require_relative '../extern_object'

module Tgui
  class Font < ExternObject
    def self.produce arg
      case arg
      when Font
        return arg
      when String
        id = expand_path arg
      else
        raise "Unsupported argument #{arg}"
      end
      Font.new id
    end

    def self.expand_path path
      path = File.expand_path(path, File.dirname($0))
      raise "File #{path} not found" if !File.exist? path
      path
    end
  end
end