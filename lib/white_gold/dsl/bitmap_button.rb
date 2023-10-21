require_relative 'button'

module Tgui
  class BitmapButton < Button

    abi_attr :image_scaling

    def image=(image)
      _abi_set_image Texture.produce(image)
    end

    def image
      _abi_get_image
    end
  end
end