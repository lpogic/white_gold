require 'tempfile'
require_relative '../abi/extern_object'
require_relative '../convention/bang_nest'
require_relative '../convention/theme/theme_attributed'

module Tgui
  class Theme < ExternObject
    include BangNest
    extend ThemeAttributed
    
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
      
      def loadpath seed
        case seed
        when :light then File.dirname(File.dirname(__FILE__)) + '/library/theme/light.rb'
        when String then Util.expand_path(seed)
        else raise "#{seed} not available"
        end
      end

      def api_attr name, &init
        define_method "#{name}=" do |value|
          @@data_storage[Theme.get_unshared(@pointer).to_i][name] = value
        end
  
        init ||= proc{ nil }
  
        define_method name do
          @@data_storage[Theme.get_unshared(@pointer).to_i][name] ||= init.()
        end
      end
    end

    abi_static :get_unshared

    api_attr :attributes do
      {}
    end
    api_attr :next_renderer_id do
      "_0"
    end

    attr :source
    def source=(path)
      @source = Util.expand_path(path)
    end

    def reset_attributes
      self.attributes = {}
    end

    @@debug = false
    def debug=(debug)
      @@debug = debug
    end

    def! :custom do |type, seed, **na, &b|
      self.next_renderer_id = renderer_id = next_renderer_id.next
      attribute = type.new(seed, renderer_id)
      attributes[attribute.name] = attribute
      attribute.host! **na, &b
      self_commit
      renderer_id
    end

    def self_commit custom_rendered = nil
      if attributes.size > 0
        file = Tempfile.new
        begin
          if @source
            File.foreach @source do |line|
              file << line
            end
          end
          attributes.each do |k, v|
            file << v.to_theme << "\n"
          end
          file.close
          puts File.readlines(file.path) if @@debug
          _abi_load file.path
        ensure
          file.close!
        end
      else
        _abi_load @source if @source
      end
      custom_rendered&.each do |widget, renderer|
        widget.self_set_renderer renderer
      end
    end
  end
end