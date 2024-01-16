require_relative '../abi/extern_object'

module Tgui
  class Color < ExternObject

    PREDEFINED_COLORS = {
      red: [200, 0, 0, 255],
      green: [0, 200, 0, 255],
      blue: [0, 0, 200, 255],
      yellow: [200, 200, 0, 255],
      white: [255, 255, 255, 255],
      black: [0, 0, 0, 255]
    }

    def self.from *arg
      case arg.size
      when 1
        arg = arg.first
        case arg
        when Color
          return arg
        when String
          r, g, b, a = *tones_from_string(arg)
        when :random
          r, g, b = 5.times.map{ rand 255 }
          a = 255
        when Symbol
          r, g, b, a = *PREDEFINED_COLORS[arg]
        when Numeric
          r = g = b = arg
          a = 255
        else raise "Unsupported argument #{arg} #{arg.class}"
        end
      when 2
        r = g = b = arg[0]
        a = arg[1]
      when 3
        r, g, b = *arg
        a = 255
      when 4
        r, g, b, a = *arg
      else raise "Unsupported argument #{arg}"
      end
      Color.new r, g, b, a
    end

    abi_def :red, :get_, nil => Integer
    abi_def :green, :get_, nil => Integer
    abi_def :blue, :get_, nil => Integer
    abi_def :alpha, :get_, nil => Integer
    abi_def :fade, :apply_opacity, Float => Color

    def brightness
      Color.rgb_to_hsv(red, green, blue)[2]
    end

    def lighter light
      h, s, v = *Color.rgb_to_hsv(red, green, blue)
      Color.new *Color.hsv_to_rgb(h, s, (v + light).clamp(0, 255)), alpha
    end

    def darker shadow
      h, s, v = *Color.rgb_to_hsv(red, green, blue)
      Color.new *Color.hsv_to_rgb(h, s, (v - shadow).clamp(0, 255)), alpha
    end

    def to_arr
      [red, green, blue, alpha]
    end

    def to_s
      "##{to_arr.map{ _1.to_s(16).ljust(2, '0') }.join}"
    end

    def inspect
      to_s
    end

    def self.tones_from_string str
      str.delete_prefix("#").scan(/../).map(&:hex) + Array.new(4, 255)
    end

    def self.rgb_to_hsv(red, green, blue)
      min, max = *[red, green, blue].minmax
      mdiff = max - min
      if min == max
        hue = 0.0
      elsif red == max
        hue = (green - blue) * 43.0 / mdiff
      elsif green == max
        hue = 85 + (blue - red) * 43.0 / mdiff
      else
        hue = 171 + (red - green) * 43.0 / mdiff
      end

      hue += 256 if hue < 0
      saturation = max > 0 ? mdiff * 255.0 / max : 0.0
      [hue, saturation, max].map(&:round)
    end

    def self.hsv_to_rgb(hue, saturation, value)
      return [value, value, value] if saturation == 0

      region = hue / 43;
      remainder = (hue - (region * 43.0)) * 6; 
      
      x = (255.0 - saturation) * value / 256.0;
      y = (255.0 - ((saturation * remainder) / 256.0)) * value / 256.0;
      z = (255.0 - ((saturation * (255.0 - remainder)) / 256.0)) * value / 256.0;
      
      return case region
      when 0
        [value, z, x]
      when 1
        [y, value, x]
      when 2
        [x, value, z]
      when 3
        [x, y, value]
      when 4
        [z, x, value]
      else
        [value, x, y]
      end.map(&:round)
    end
  end
end