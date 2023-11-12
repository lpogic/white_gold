require_relative '../extern_object'

module Tgui
  class Texture < ExternObject
    def self.produce arg
      case arg
      when Texture
        return arg
      when String
        id = Util.expand_path arg
        prx = pry = prw = prh = mpx = mpy = mpw = mph = 0
        smooth = Texture.default_smooth
      when Array
        id = Util.expand_path arg[0]
        prx = arg[1] || 0
        pry = arg[2] || 0
        prw = arg[3] || 0
        prh = arg[4] || 0
        mpx = arg[5] || 0
        mpy = arg[6] || 0
        mpw = arg[7] || 0
        mph = arg[8] || 0
        smooth = arg[9] || Texture.default_smooth
      else
        raise "Unsupported argument #{arg}"
      end
      Texture.new id, prx, pry, prw, prh, mpx, mpy, mpw, mph, smooth
    end

    abi_alias :id, :get_

    def image_size
      size = _abi_get_image_size
      [size.x, size.y]
    end

    def part_rect
      rect = _abi_get_part_rect
      [rect.left, rect.top, rect.width, rect.height]
    end

    abi_alias :smooth?

    def color=(color)
      c = Color.produce color
      _abi_set_color c
    end

    abi_alias :color, :get_

    def self.default_smooth=(smooth)
      _abi_set_default_smooth smooth
    end

    def self.default_smooth
      _abi_get_default_smooth
    end

  end
end