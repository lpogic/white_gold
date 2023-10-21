require_relative 'container'

module Tgui
  class Grid < Container
    Alignment = enum :center, :upper_left, :up, :upper_right, :right, :bottom_right, :botton, :bottom_left, :left
    
    class PaddingAttr
      def initialize grid
        @grid = grid
      end

      def [](*a)
        widget = @grid.get *a
        _abi_get_widget_padding @grid, widget if widget
      end

      def []=(*a, value)
        widget = @grid.get *a
        _abi_set_widget_padding @grid, widget, *value_to_padding(value) if widget
      end

      def value_to_padding v
        if !v
          Array.new(4, 0)
        elsif Array === v
          case v.size
          when 1 then Array.new(4, v[0])
          when 2 then [v[0], v[0], v[1], v[1]]
          when 3 then [v[0], v[1], v[2], v[2]]
          when 4 then v
          else raise "Invalid array size #{v}"
          end
        else
          Array.new(4, v)
        end
      end
    end

    class AlignmentAttr
      def initialize grid
        @grid = grid
      end

      def [](*a)
        widget = @grid.get *a
        Alignment[_abi_get_widget_alignment @grid, widget] if widget
      end

      def []=(*a, value)
        widget = @grid.get *a
        _abi_set_widget_padding @grid, widget, Alignment[value] if widget
      end
    end

    class CellAttr
      def initialize grid
        @grid = grid
      end

      def []=(*a, value)
        widget = @grid.get *a
        _abi_set_widget_cell @grid, widget, *value if widget
      end
    end

    def initialized
      super
      @current_row = 0
      @current_column = 0
    end

    def padding
      PaddingAttr.new self
    end

    def alignment
      AlignmentAttr.new self
    end

    def cell
      CellAttr.new self
    end

    def get *a
      case a.size
      when 1 then super *a
      when 2 then _abi_get_widget @pointer, *a
      else nil
      end
    end

    def add widget, name = nil
      super
      _abi_set_widget_cell @pointer, widget, @current_row, @current_column
      @current_column += 1
    end

    def next_row
      @current_column = 0
      @current_row += 1
    end
  end
end