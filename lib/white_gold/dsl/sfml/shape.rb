require_relative '../../abi/extern_object'
require_relative '../color'
require_relative '../texture'

module Tgui
  class Shape < ExternObject
    include Extree

    abi_attr :texture, Texture
    abi_attr :radius, Float
    abi_attr :point_count, Integer
    abi_attr :color, Color, :fill_color
    abi_attr :border_color, Color, :outline_color
    abi_attr :border, Float, :outline_thickness
    abi_attr :position, Vector2f
    abi_attr :rotation, Float
    abi_attr :scale, Vector2f
    abi_attr :origin, Vector2f
  end
end