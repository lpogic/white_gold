require_relative 'container'

module Tgui
  class Grid < Container

    api_attr :cell do
      [0, 0]
    end

    api_attr :alignment do
      nil
    end

    api_attr :direction do
      :column
    end

    api_attr :padding do
      nil
    end

    api_child :padding= do |w, padding|
      _abi_set_widget_padding w, abi_pack(Outline, *padding)
    end

    api_child :padding do |w|
      abi_unpack(Outline, _abi_get_widget_padding(w))
    end

    abi_enum "Alignment", :center, :upper_left, :up, :upper_right, :right, :bottom_right, :bottom, :bottom_left, :left,
      top_left: :upper_left, left_top: :upper_left,
      top_right: :upper_right, right_top: :upper_right,
      right_bottom: :bottom_right, left_bottom: :bottom_left

    api_child :alignment= do |w, alignment|
      _abi_set_widget_alignment w, abi_pack(Alignment, alignment)
    end

    api_child :alignment do |w|
      abi_unpack(Alignment, _abi_get_widget_alignment(w))
    end

    api_child :alignment do |w|
      Alignment[_abi_get_widget_alignment]
    end

    api_child :cell= do |w, cell|
      _abi_set_widget_cell w, abi_pack_integer(cell[0]), abi_pack_integer(cell[1])
    end

    abi_attr :auto_size?

    def next_row reset_column = true
      c = cell
      self.cell = [c[0] + 1, reset_column ? 0 : c[1]]
    end

    def! :next_row do
      next_row
    end

    def next_column reset_row = true
      c = cell
      self.cell = [reset_row ? 0 : c[0], c[1] + 1]
    end

    def! :next_column do
      next_column
    end

    def! :next do
      direction == :column ? next_row : next_column
    end

    def widgets
      widgets = {}
      block_caller = Fiddle::Closure::BlockCaller.new(0, 
        [Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP, Fiddle::TYPE_INT, Fiddle::TYPE_INT]) do |pointer, type, row, column|
        widgets[[row, column]] = self_cast_up(pointer, abi_unpack_string(type))
      end
      _abi_get_widget_locations block_caller
      return widgets
    end

    def add widget, id
      super
      _abi_set_widget_cell abi_pack(Widget, widget), *cell
      _abi_set_widget_alignment abi_pack(Widget, widget), abi_pack(Alignment, alignment) if alignment
      _abi_set_widget_padding abi_pack(Widget, widget), abi_pack(Outline, *padding) if padding
      if direction == :column
        next_column false
      else
        next_row false
      end
    end

    def get(*keys)
      case keys
      in [Symbol]
        id = page.clubs[keys.first]&.members&.first
        id && self_cast_up(_abi_get(abi_pack_string id))
      in [Integer, Integer]
        self_cast_up(_abi_get_widget *keys)
      else
        Enumerator.new do |e|
          Array(self_get_widget_name keys).flatten.compact.uniq.each do |id|
            w = _abi_get(abi_pack_string id)
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