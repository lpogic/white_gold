require_relative 'box_layout'

class Tgui
  class BoxLayoutRatios < BoxLayout
    class Ratios
      def initialize box
        @box = box
      end

      def [](i)
        case i
        when Integer
          Private.get_ratio_by_index @box, i, ratio
        when Widget
          Private.get_ratio @box, i, ratio
        else
          i = @box.get i
          Private.get_ratio @box, i, ratio
        end
      end

      def []=(i, ratio)
        case i
        when Integer
          Private.set_ratio_by_index @box, i, ratio
        when Widget
          Private.set_ratio @box, i, ratio
        else
          i = @box.get i
          Private.set_ratio @box, i, ratio
        end
      end
    end

    def ratio
      Ratios.new self
    end
  end
end