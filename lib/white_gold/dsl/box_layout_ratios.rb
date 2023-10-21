require_relative 'box_layout'

module Tgui
  class BoxLayoutRatios < BoxLayout
    class Ratios
      def initialize box
        @box = box
      end

      def [](i)
        case i
        when Integer
          _abi_get_ratio_by_index @box, i, ratio
        when Widget
          _abi_get_ratio @box, i, ratio
        else
          i = @box.get i
          _abi_get_ratio @box, i, ratio
        end
      end

      def []=(i, ratio)
        case i
        when Integer
          _abi_set_ratio_by_index @box, i, ratio
        when Widget
          _abi_set_ratio @box, i, ratio
        else
          i = @box.get i
          _abi_set_ratio @box, i, ratio
        end
      end
    end

    def ratio
      Ratios.new self
    end
  end
end