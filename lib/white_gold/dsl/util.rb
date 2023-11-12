require_relative '../extern_object'

module Tgui
  class Util < ExternObject

    abi_static :free

    def self.expand_path path
      path = File.expand_path(path, File.dirname($0))
      raise "File #{path} not found" if !File.exist? path
      path
    end

  end
end