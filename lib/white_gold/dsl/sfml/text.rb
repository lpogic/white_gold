require_relative '../../abi/extern_object'
require_relative '../font'
require_relative '../color'

module Tgui
  class Text < ExternObject
    include BangNest

    abi_attr :string, String
    abi_attr :font, Font
    abi_attr :character_size, Integer
    abi_attr :line_spacing, Float
    abi_attr :letter_spacing, Float
    abi_attr :style, TextStyles
    abi_attr :color, Color, :fill_color
    abi_attr :border_color, Color, :outline_color
    abi_attr :border, Float, :outline_thickness
    abi_def :character_position, :find_character_pos, Integer => Vector2f
    abi_attr :position, Vector2f
    abi_attr :rotation, Float
    abi_attr :scale, Vector2f
    abi_attr :origin, Vector2f

    def self.finalizer pointer
      _abi_delete pointer
    end
  end
end