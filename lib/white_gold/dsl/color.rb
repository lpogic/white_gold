require_relative '../extern_object'

module Tgui
  class Color < ExternObject

    PREDEFINED_COLORS = {
      red: [200, 0, 0, 255],
      green: [0, 200, 0, 255],
      blue: [0, 0, 200, 255],
      yellow: [200, 200, 0, 255],
      white: [200, 200, 200, 255],
      black: [0, 0, 0, 255]
    }

    def self.produce arg
      case arg
      when Color
        return arg
      when String
        r, g, b, a = *tones_from_string(arg)
      when Symbol
        r, g, b, a = *PREDEFINED_COLORS[arg]
      when Array
        case arg.size
        when 1
          r = g = b = arg[0]
          a = 255
        when 2
          r = g = b = arg[0]
          a = arg[1]
        when 3
          r, g, b = *arg
          a = 255
        else
          r, g, b, a = *arg
        end
      else
        raise "Unsupported argument #{arg}"
      end
      Color.new r, g, b, a
    end

    abi_alias :red, :get_
    abi_alias :green, :get_
    abi_alias :blue, :get_
    abi_alias :alpha, :get_
    abi_alias :fade, :apply_opacity

    def to_a
      [red, green, blue, alpha]
    end

    def inspect
      "##{to_a.map{ _1.to_s 16}.join}"
    end

    def self.tones_from_string str
      str.delete_prefix("#").scan(/../).map(&:hex) + Array.new(4, 255)
    end
  end
end