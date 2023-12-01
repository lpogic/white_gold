require 'tempfile'
require_relative '../abi/extern_object'
require_relative '../convention/bang_nest'

module Tgui
  class Theme < ExternObject
    include BangNest
    class << self

      def default=(theme)
        _abi_set_default Util.expand_path(theme)
      end

      def default
        self.new pointer: _abi_get_default
      end

      def finalizer pointer
        _abi_finalizer pointer
      end
    end

    def initialize ...
      super
      @temporary_properties = {}
    end

    def load path
      _abi_load Util.expand_path(path)
    end

    def text_color=(color)
      @temporary_properties["TextColor"] = Color.from(*color)
    end

    def text_color_hover=(color)
      @temporary_properties["TextColorHover"] = Color.from(*color)
    end

    def border_color=(color)
      @temporary_properties["BorderColor"] = Color.from(*color)
    end

    def background_color=(color)
      @temporary_properties["BackgroundColor"] = Color.from(*color)
    end

    def self_commit
      if @temporary_properties.size > 0
        file = Tempfile.new
        begin
          @temporary_properties.each do |k, v|
            file << "#{k} = #{v};" << "\n"
          end
          file.close
          p File.readlines(file.path)
          load file.path
        ensure
          file.close!
        end
        @temporary_properties.clear
      end
    end
  end
end