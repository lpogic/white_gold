require 'fiddle/import'
require_relative 'path/fiddle-pointer.path'
require_relative 'tgui-config'
require_relative 'extern_object'
require_relative 'extern_enum'

class Tgui

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
  end

  ShowEffectType = enum :fade, :scale, :slide_to_right, :slide_to_left, :slide_to_bottom,
    :slide_to_top, slide_from_left: :slide_to_right, slide_from_right: :slide_to_left,
    slide_from_top: :slide_to_bottom, slide_from_bottom: :slide_to_top

  AnimationType = enum :move, :resize, :opacity

  TextStyle = bit_enum :regular, :bold, :italic, :underlined, :strike_through
end

dsl_dir = File.dirname(__FILE__) + "/dsl"
Dir.each_child dsl_dir do |filename|
  require_relative "dsl/#{filename}"
end
# ABI loader should be required last
require_relative '../generated/tgui-abi-loader.gf'
