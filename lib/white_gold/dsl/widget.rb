require_relative '../extern_object'
require_relative '../convention/bang_nested_caller'
require_relative '../convention/unit'
require_relative '../convention/widget_like'
require_relative 'signal/signal'
require_relative 'signal/signal_vector2f'
require_relative 'signal/signal_show_effect'
require_relative 'signal/signal_animation_type'
require_relative 'tool_tip'

module Tgui
  class Widget < ExternObject
    include BangNestedCaller

    attr_accessor :page

    abi_attr :text_size
    abi_attr :enabled?
    abi_attr :focused?
    abi_attr :focusable?
    abi_signal :on_position_change, Tgui::SignalVector2f
    abi_signal :on_size_change, Tgui::SignalVector2f
    abi_signal :on_focus, Tgui::Signal
    abi_signal :on_unfocus, Tgui::Signal
    abi_signal :on_mouse_enter, Tgui::Signal
    abi_signal :on_mouse_leave, Tgui::Signal
    abi_signal :on_show_effect_finish, Tgui::SignalShowEffect
    abi_signal :on_animation_finish, Tgui::SignalAnimationType

    def position=(position)
      a = Array(position)
      x = self_encode_position_layout(a[0])
      y = self_encode_position_layout(a[1] || a[0])
      _abi_set_position x, y
    end

    def position
      vec = _abi_get_position
      [vec.x, vec.y]
    end

    def absolute_position
      vec = _abi_get_absolute_position
      [vec.x, vec.y]
    end

    def size=(size)
      a = Array(size)
      w = self_encode_size_layout(a[0])
      h = self_encode_size_layout(a[1] || a[0])
      _abi_set_size w, h
    end

    def size
      vec = _abi_get_size
      [vec.x, vec.y]
    end

    def full_size
      vec = _abi_get_full_size
      [vec.x, vec.y]
    end

    def height=(height)
      h = self_encode_size_layout(height)
      _abi_set_height h
    end

    def height
      size[1]
    end

    def width=(width)
      w = self_encode_size_layout(width)
      _abi_set_width w
    end

    def width
      size[0]
    end

    abi_alias :can_gain_focus?
    abi_alias :container?, :is_

    def tooltip *a, **na, &b
      if block_given?
        tooltip = ToolTip.new
        tooltip.page = page
        bang_nest tooltip, **na, &b
        _abi_set_tool_tip tooltip.widget if tooltip.widget
      else
        widget = _abi_get_tool_tip
        return nil if widget.null?
        tooltip = ToolTip.new
        tooltip.widget = widget
        return tooltip
      end
    end

    CursorType = enum :arrow, :text, :hand, :size_left, :size_right,
      :size_top, :size_bottom, :size_top_left, :size_bottom_right,
      :size_bottom_left, :size_top_right, :size_horizontal, :size_vertical,
      :crosshair, :help, :not_allowed

    def mouse_cursor=(cursor)
      _abi_set_mouse_cursor CursorType[cursor]
    end

    def mouse_cursor
      CursorType[_abi_get_mouse_cursor]
    end

    abi_alias :draggable?, :is_widget_draggable
    abi_alias :mouse_down?, :is_

    ShowEffectType = enum :fade, :scale, :slide_to_right, :slide_to_left, :slide_to_bottom,
    :slide_to_top, slide_from_left: :slide_to_right, slide_from_right: :slide_to_left,
    slide_from_top: :slide_to_bottom, slide_from_bottom: :slide_to_top

    def visible=(a)
      if a.is_a? Array
        if a[0]
          show *a[1..]
        else
          hide *a[1..]
        end
      else
        _abi_set_visible a
      end
    end

    abi_alias :visible?, :is_

    def show effect = nil, duration = 1000
      if effect
        _abi_show_with_effect ShowEffectType[effect], duration
      else
        _abi_set_visible 1
      end
    end

    def hide effect = nil, duration = 1000
      if effect
        _abi_hide_with_effect ShowEffectType[effect], duration
      else
        _abi_set_visible 0
      end
    end

    def move x, y = nil, duration = 1000
      x = self_encode_position_layout(x)
      y = self_encode_position_layout(x || y)
      _abi_move_with_animation x, y, duration
    end

    def resize width, height = nil, duration = 1000
      w = self_encode_size_layout(width)
      h = self_encode_size_layout(width || height)
      _abi_resize_with_animation w, h, duration
    end

    AnimationType = enum :move, :resize, :opacity

    abi_alias :finish_animations, :finish_all_animations
    abi_alias :front, :move_to_
    abi_alias :back, :move_to_
    
    def flags=(flags)
      flags.each do |f|
        send("#{f}=", true)
      end
    end

    def respond_to? name
      super || name.start_with?("_") || bang_respond_to?(name)
    end

    def method_missing name, *a, **na, &b
      if name.start_with? "_"
        if name.end_with? "="
          @@data_storage[Widget.get_unshared(@pointer).to_i][name[...-1]] = a[0]
        else
          @@data_storage[Widget.get_unshared(@pointer).to_i][name.to_s]
        end
      elsif name.end_with? "!"
        bang_method_missing name, *a, **na, &b
      else super
      end
    end

    # internal

    def self_encode_position_layout value
      case value
      when String then value
      when Numeric then Unit.nominate value
      when :center then "(parent.innersize - size) / 2"
      when :begin then "size / 2"
      when :end then "parent.innersize - size / 2"
      else raise "Invalid value `#{value}` given"
      end
    end    

    def self_encode_size_layout value
      case value
      when String then value
      when Numeric then Unit.nominate value
      when :full then "100%"
      when :half then "50%"
      when :third then "parent.innersize  / 3"
      when :quarter then "25%"
      else raise "Invalid value `#{value}` given"
      end
    end
  end
end
