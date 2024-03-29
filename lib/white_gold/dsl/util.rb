require_relative '../abi/extern_object'

module Tgui
  class Util < ExternObject

    abi_static :delete_vector2f
    abi_static :delete_vector2i
    abi_static :delete_u_int_rect

    def self.expand_path path, exist: true
      if !path.match?(/^\w:\//) # TODO UNIX
        path = File.expand_path(path, File.dirname(ENV["OCRAN_EXECUTABLE"] || $0))
      end
      raise "File #{path} not found" if exist && !File.exist?(path)
      path
    end

  end
end