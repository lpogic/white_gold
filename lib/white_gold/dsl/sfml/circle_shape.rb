require_relative 'shape'

module Tgui
  class CircleShape < Shape
    abi_attr :radius, Float

    def self.finalizer pointer
      _abi_delete pointer
    end
  end
end