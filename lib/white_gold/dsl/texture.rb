require_relative '../abi/extern_object'
require_relative 'color'

module Tgui
  class Texture < ExternObject

    def self.finalizer pointer
      _abi_delete pointer
    end

    def self.from *arg
      case arg.size
      when 1
        a = arg.first
        case a
        when Texture
          return a
        when String
          id = Util.expand_path a
          prx = pry = prw = prh = mpx = mpy = mpw = mph = 0
          smooth = Texture.default_smooth
        else raise "Unsupported argument #{arg}"
        end
      when 2..10
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
      else raise "Unsupported argument #{arg}"
      end
      Texture.new id, prx, pry, prw, prh, mpx, mpy, mpw, mph, smooth
    end

    abi_def :id, :get_, nil => String
    abi_def :image_size, :get_, nil => Vector2i
    abi_def :part_rect, :get_, nil => UIntRect
    abi_def :smooth?, nil => Boolean
    abi_attr :color, Color

    def to_theme
      "#{id} Part(#{part_rect.join(",")})"
    end

    def self.default_smooth=(smooth)
      _abi_set_default_smooth smooth
    end

    def self.default_smooth
      _abi_get_default_smooth
    end
  end
end