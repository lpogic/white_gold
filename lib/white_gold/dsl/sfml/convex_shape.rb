require_relative 'shape'

module Tgui
  class ConvexShape < Shape
    def initialized
      @point_count = 0
    end

    def! :point do |x, y|
      _abi_set_point_count @point_count + 1
      _abi_set_point @point_count, *abi_pack(Vector2f, x, y)
      @point_count += 1
    end

    def self.finalizer pointer
      _abi_delete pointer
    end
  end
end