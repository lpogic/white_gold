require_relative 'container'

module Tgui
  class Grid < Container

    api_child :padding= do |w, padding|
      _abi_set_widget_padding w, *self_value_to_padding(padding)
    end

    api_child :padding, :get_widget_

    Alignment = enum :center, :upper_left, :up, :upper_right, :right, :bottom_right, :bottom, :bottom_left, :left,
      top_left: :upper_left, left_top: :upper_left,
      top_right: :upper_right, right_top: :upper_right,
      right_bottom: :bottom_right, left_bottom: :bottom_left

    api_child :alignment= do |w, alignment|
      _abi_set_widget_alignment w, Alignment[alignment]
    end

    api_child :alignment do |w|
      Alignment[_abi_get_widget_alignment]
    end

    api_child :cell=, :set_widget_cell

    def self_value_to_padding v
      padding = if !v
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
      padding.map{ self_encode_padding _1 }
    end

    def self_encode_padding value
      case value
      when String then value
      when Numeric then "#{value}"
      else raise "Invalid value `#{value}` given"
      end
    end

    abi_attr :auto_size?

    def initialized
      super
      @current_row = 0
      @current_column = 0
    end

    def next_row
      @current_column = 0
      @current_row += 1
    end

    def widgets
      widgets = {}
      block_caller = Fiddle::Closure::BlockCaller.new(0, 
        [Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP, Fiddle::TYPE_INT, Fiddle::TYPE_INT]) do |pointer, type, row, column|
        widgets[[row, column]] = self_cast_up(pointer, type.utf32_to_s)
      end
      _abi_get_widget_locations block_caller
      return widgets
    end

    def add widget, id
      super
      _abi_set_widget_cell widget, @current_row, @current_column
      @current_column += 1
    end

    def get(*keys)
      case keys
      in [Symbol]
        id = page.clubs[keys.first]&.members&.first
        id && self_cast_up(_abi_get(id.to_s))
      in [Integer, Integer]
        self_cast_up(_abi_get_widget *keys)
      else
        Enumerator.new do |e|
          Array(self_get_widget_name keys).flatten.compact.uniq.each do |id|
            w = _abi_get(id.to_s)
            e << self_cast_up(w) if w && !w.null?
          end
        end
      end      
    end

    # internal

    def self_get_widget_name a
      case a
      in Widget
        a.name
      in [Integer, Integer]
        w = _abi_get_widget *a
        return nil if w.null?
        self_cast_up(w, equip: false).name
      in Enumerable
        a.map{ self_get_widget_name _1 }.flatten
      else
        page.clubs[a]&.members
      end
    end
  end
end