require_relative 'widget'

module Tgui
  class Container < Widget

    def widgets
      widgets = []
      block_caller = Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP]) do |pointer, type|
        widgets << self_cast_up(pointer, abi_pack_string(type))
      end
      _abi_get_widgets block_caller
      return widgets
    end
    
    abi_def :add
    abi_def :remove_all
    abi_def :inner_size, :get_, nil => Vector2f
    abi_def :child_offset, :get_, nil => Vector2f
    abi_def :remove, Widget => nil

    def move_front widget, ceil = false
      widget = abi_pack_widget widget
      if ceil
        _abi_move_widget_to_front widget
      else
        _abi_move_widget_forward widget
      end
    end

    def move_back widget, floor = false
      widget = abi_pack_widget widget
      if floor
        _abi_move_widget_to_back widget
      else
        _abi_move_widget_backward widget
      end
    end

    def move_at index, widget
      _abi_set_widget_index abi_pack_widget(widget), abi_pack_integer(index)
    end

    abi_def :index, :get_widget_, Widget => Integer
    abi_def :focused_child, :get_, nil => Widget
    abi_def :focused_leaf, :get_, nil => Widget
    abi_def :leaf_at_position, :get_widget_at_position, [Float, Float] => Widget
    abi_def :focus_next, :focus_next_widget
    abi_def :focus_previous, :focus_previous_widget

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

    def abi_pack_widget o
      case o
      when Symbol
        self[o]
      when Widget
        o
      else
        raise "Unable to make Widget from #{o}"
      end
    end

    def abi_unpack_widget o
      self_cast_up o
    end

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