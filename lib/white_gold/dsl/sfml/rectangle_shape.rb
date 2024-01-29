require_relative 'shape'

module Tgui
  class RectangleShape < Shape
    abi_attr :size, Vector2f

    def self.finalizer pointer
      _abi_delete pointer
    end
  end
end