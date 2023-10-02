require_relative 'button'

class Tgui
  class BitmapButton < Button
    def image=(image)
      Private.set_image @pointer, Texture.produce(image)
    end
  end
end