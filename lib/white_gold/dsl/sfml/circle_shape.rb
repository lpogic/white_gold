require_relative 'shape'

module Tgui
  class CircleShape < Shape
    abi_attr :radius, Float
  end
end