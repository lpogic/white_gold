require_relative '../extern_object'

class Tgui
  class Texture < ExternObject
    def self.produce arg
      case arg
      when Texture
        return arg
      when String
        id = expand_path arg
        prx = pry = prw = prh = mpx = mpy = mpw = mph = 0
        smooth = false
      when Array
        id = expand_path arg[0]
        prx = arg[1] || 0
        pry = arg[2] || 0
        prw = arg[3] || 0
        prh = arg[4] || 0
        smooth = arg[5] || false
        mpx = arg[6] || 0
        mpy = arg[7] || 0
        mpw = arg[8] || 0
        mph = arg[9] || 0
      else
        raise "Unsupported argument #{arg}"
      end
      Texture.new id, prx, pry, prw, prh, mpx, mpy, mpw, mph, smooth
    end

    def self.expand_path path
      path = File.expand_path(path, File.dirname($0))
      raise "File #{path} not found" if !File.exist? path
      path
    end
  end
end