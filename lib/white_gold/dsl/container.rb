require_relative 'widget'

module Tgui
  class Container < Widget

    def widgets
      widgets = []
      block_caller = Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP]) do |pointer, type|
        widgets << self_cast_up(pointer, type.utf32_to_s)
      end
      _abi_get_widgets block_caller
      return widgets
    end

    abi_alias :add
    abi_alias :remove_all
    abi_alias :inner_size, :get_
    abi_alias :child_offset, :get_

    def remove widget
      widget = self[widget] if widget.is_a? Symbol
      _abi_remove widget
    end

    def move_front widget, ceil = false
      widget = self[widget] if widget.is_a? Symbol
      if ceil
        _abi_move_widget_to_front widget
      else
        _abi_move_widget_forward widget
      end
    end

    def move_back widget, floor = false
      widget = self[widget] if widget.is_a? Symbol
      if floor
        _abi_move_widget_to_back widget
      else
        _abi_move_widget_backward widget
      end
    end

    def move_at index, widget
      widget = self[widget] if widget.is_a? Symbol
      _abi_set_widget_index widget, index
    end

    def index widget
      widget = self[widget] if widget.is_a? Symbol
      _abi_get_widget_index widget
    end

    def focused_child
      self_cast_up _abi_get_focused_child
    end

    def focused_leaf
      self_cast_up _abi_get_focused_leaf
    end

    def leaf_at_position x, y
      self_cast_up _abi_get_widget_at_position(x, y)
    end

    abi_alias :focus_next, :focus_next_widget
    abi_alias :focus_previous, :focus_previous_widget

    def get(*keys)
      case keys
      in [Symbol]
        id = page.clubs[keys.first]&.members&.first
        id && self_cast_up(_abi_get(id.to_s))
      else
        Enumerator.new do |e|
          Array(self_get_widget_name keys).flatten.compact.uniq.each do |id|
            w = _abi_get(id.to_s)
            e << self_cast_up(w) if w && !w.null?
          end
        end
      end      
    end

    alias_method :[], :get

    # internal

    def self_get_widget_name a
      case a
      when Widget
        a.name
      when Enumerable
        a.map{ self_get_widget_name _1 }.flatten
      else
        page.clubs[a]&.members
      end
    end
  end
end