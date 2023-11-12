require 'fiddle/import'
require_relative 'path/fiddle-pointer.path'
require_relative 'tgui-config'
require_relative 'extern_object'
require_relative 'extern_enum'

module Tgui

  module Abi
    extend Fiddle::Importer
    
    begin
      Config::LIBS.each{ dlload _1 }
    rescue LoadError
      raise LoadError, 'Could not find shared library'
    end

    def self.call_arg_map! a
      a.map! do
        case _1
        when ExternObject then _1.pointer
        when true then 1
        when false then 0
        else _1
        end
      end
    end

    Vector2f = struct [
      'float x',
      'float y'
    ]

    Vector2u = struct [
      'int x',
      'int y'
    ]

    UIntRect = struct [
      'int left',
      'int top',
      'int width',
      'int height'
    ]
  end

  TextStyles = bit_enum :regular, :bold, :italic, :underlined, :strike_through

  CursorType = enum :arrow, :text, :hand, :size_left, :size_right,
    :size_top, :size_bottom, :size_top_left, :size_bottom_right,
    :size_bottom_left, :size_top_right, :size_horizontal, :size_vertical,
    :crosshair, :help, :not_allowed
end

def each_file_ancestor base, dir, &b
  base_dir = "#{base}/#{dir}"
  Dir.each_child base_dir do |filename|
    if File.directory? "#{base_dir}/#{filename}"
      each_file_ancestor base, "#{dir}/#{filename}", &b
    else
      b.("#{dir}/#{filename}")
    end
  end
end

each_file_ancestor File.dirname(__FILE__), "dsl" do |dsl_file|
  require_relative dsl_file
end

# ABI loader should be required after dsl directory files because of class hierarchy
require_relative '../generated/tgui-abi-loader.gf'
require_relative 'convention/container_widgets'
