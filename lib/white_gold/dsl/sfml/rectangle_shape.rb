require_relative 'shape'

module Tgui
  class RectangleShape < Shape
    abi_attr :size, Vector2f
  end
end