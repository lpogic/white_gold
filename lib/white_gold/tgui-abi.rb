require 'fiddle/import'
require_relative 'tgui-config'
require_relative 'abi/extern_object'
require_relative 'abi/enum'

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

  Vector2f = Abi::Vector2f
  Vector2u = Abi::Vector2u
  UIntRect = Abi::UIntRect
end

class ExternObject
   
  abi_bit_enum "TextStyles", :regular, :bold, :italic, :underlined, :strike_through

  abi_enum "CursorType", :arrow, :text, :hand, :size_left, :size_right,
    :size_top, :size_bottom, :size_top_left, :size_bottom_right,
    :size_bottom_left, :size_top_right, :size_horizontal, :size_vertical,
    :crosshair, :help, :not_allowed

  abi_bit_enum "WindowStyle", :none, :titlebar, :resize, :close, :fullscreen, :topmost, default: 7

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
require_relative 'generated/tgui-abi-loader.gf'
require_relative 'convention/widget_class_aliases'
require_relative 'convention/container_widgets'
require_relative 'convention/theme_attributes'

class ExternObject
  class << self
    def finalizer pointer
      Tgui::Util.free(pointer)
    end
  end

  abi_packer Object do |o|
    o = o.first if o.is_a? Array
    o
  end

  abi_packer String do |o|
    o = o.first if o.is_a? Array
    o.to_s
  end

  abi_packer Integer do |o|
    o = o.first if o.is_a? Array
    o.to_i
  end

  abi_packer Float do |o|
    o = o.first if o.is_a? Array
    o.to_f
  end

  abi_packer Boolean do |o|
    o = o.first if o.is_a? Array
    o ? 1 : 0
  end

  abi_packer "SizeLayout" do |*arg|
    case arg.size
    when 1
      a = arg.first
      x = y = a
    when 2
      x, y = *arg
    else raise "Unsupported argument #{arg}"
    end
    [abi_pack_single_size_layout(x), abi_pack_single_size_layout(y)]
  end

  abi_packer "SingleSizeLayout" do |o|
    o = o.first if o.is_a? Array
    case o
    when String then o
    when Numeric then Unit.nominate o
    when :full then "100%"
    when :half then "50%"
    when :third then "parent.innersize  / 3"
    when :quarter then "25%"
    else raise "Invalid value `#{o}` given"
    end
  end

  abi_packer "PositionLayout" do |*arg|
    case arg.size
    when 1
      a = arg.first
      x = y = a
    when 2
      x, y = *arg
    else raise "Unsupported argument #{arg}"
    end
    [abi_pack_single_position_layout(x), abi_pack_single_position_layout(y)]
  end

  abi_packer "SinglePositionLayout" do |o|
    o = o.first if o.is_a? Array
    case o
    when String then o
    when Rational then "(parent.innersize - size) * #{o.numerator} / #{o.denominator}"
    when Numeric then Unit.nominate o
    when :center then "(parent.innersize - size) / 2"
    when :begin then "0"
    when :end then "parent.innersize - size"
    else raise "Invalid value `#{o}` given"
    end
  end

  abi_packer Tgui::Abi::Vector2f do |*arg|
    case arg.size
    when 1
      a = arg.first
      x = y = a
    when 2
      x, y = *arg
    else raise "Unsupported argument #{arg}"
    end
    [abi_pack_float(x), abi_pack_float(y)]
  end

  abi_packer Tgui::Abi::Vector2u do |*arg|
    case arg.size
    when 1
      a = arg.first
      x = y = a
    when 2
      x, y = *arg
    else raise "Unsupported argument #{arg}"
    end
    [abi_pack_integer(x), abi_pack_integer(y)]
  end

  abi_packer Tgui::Abi::UIntRect do |*arg|
    case arg.size
    when 1
      a = [arg.first] * 4
    when 2
      a = [arg[0], arg[0], arg[1], arg[1]]
    when 4
      a = arg
    else raise "Unsupported argument #{arg}"
    end
    a.map{ abi_pack_integer _1 }
  end

  abi_packer Tgui::Color
  abi_packer Tgui::Outline
  abi_packer Tgui::Font
  abi_packer Tgui::Texture

  abi_unpacker String do |o|
    a = []
    (0..).each do |i|
      i *= 4
      ch = (o[i] & 0xFF) | ((o[i + 1] & 0xFF) << 8) | ((o[i + 2] & 0xFF) << 16) | ((o[i + 3] & 0xFF) << 24)
      break if ch == 0
      a << ch
    end
    a.pack("N*").encode("UTF-8", "UTF-32BE")
  end

  abi_unpacker Integer do |o|
    o
  end

  abi_unpacker Float do |o|
    o
  end

  abi_unpacker Boolean do |o|
    o.odd?
  end

  vector2f_unpacker = proc do |o|
    v = Tgui::Vector2f.new o
    r = [v.x, v.y]
    Tgui::Util.free(o)
    r
  end

  abi_unpacker "SizeLayout", &vector2f_unpacker

  abi_unpacker "PositionLayout", &vector2f_unpacker

  abi_unpacker Tgui::Vector2f, &vector2f_unpacker

  abi_unpacker Tgui::Vector2u do |o|
    v = Tgui::Vector2u.new o
    r = [v.x, v.y]
    Tgui::Util.free(o)
    r
  end

  abi_unpacker Tgui::UIntRect do |o|
    v = Tgui::UIntRect.new o
    r = [v.left, v.top, v.width, v.height]
    Tgui::Util.free(o)
    r
  end

  abi_unpacker Tgui::Color
  abi_unpacker Tgui::Outline
  abi_unpacker Tgui::Font
  abi_unpacker Tgui::Texture

end