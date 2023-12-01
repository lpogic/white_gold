require_relative 'button'
require_relative 'texture'

module Tgui
  class BitmapButton < Button

    abi_attr :image_scaling, Float
    abi_attr :image, Texture
    
  end
end