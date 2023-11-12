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

    KeyCode = enum nil, :a, :b, :c, :d, :e, :f, :g, :h, :i, :j, :k, 
      :l, :m, :n, :o, :p, :q, :r, :s, :t, :u, :v, :w, :x, :y, :z,
      :num0, :num1, :num2, :num3, :num4, :num5, :num6, :num7, :num8, :num9,
      :escape, :left_control, :left_shift, :left_alt, :left_system,
      :right_control, :right_shift, :right_alt, :right_system,
      :menu, :left_bracket, :right_bracket, :semicolon, :comma,
      :period, :quote, :slash, :backslash, :tilde, :equal, :minus,
      :space, :enter, :backspace, :tab, :page_up, :page_down, :end,
      :home, :insert, :delete, :add, :substract, :multiply, :divide,
      :left, :right, :up, :down, :numpad0, :numpad1, :numpad2, :numpad3, 
      :numpad4, :numpad5, :numpad6, :numpad7, :numpad8, :numpad9,
      :f1, :f2, :f3, :f4, :f5, :f6, :f7, :f8, :f9, :f10, :f11, :f12,
      :f13, :f14, :f15, :pause

    class Robot < WidgetLike
      def initialize widget
        @widget = widget
      end

      def mouse_move x, y
        @widget._abi_mouse_moved x, y
      end

      def mouse_press x, y, down: false
        @widget._abi_left_mouse_pressed x, y
        mouse_release x, y if !down
      end

      def mouse_release x, y
        @widget._abi_left_mouse_released x, y
      end

      def right_mouse_press x, y
        @widget._abi_right_mouse_pressed x, y
      end

      def right_mouse_release x, y
        @widget._abi_right_mouse_released x, y
      end

      def key_press key, alt: false, control: false, shift: false, system: false
        @widget._abi_key_pressed KeyCode[key], alt, control, shift, system
      end

      def text text
        text.each_codepoint do |cp|
          @widget._abi_text_entered cp
        end
      end

      def scroll delta, x, y, touch = false
        @widget._abi_scrolled delta, x, y, touch
      end

      def tooltip x, y
        @widget._abi_ask_tool_tip x, y
      end
    end

    def robot **na, &b
      robot = Robot.new self
      bang_nest robot, **na, &b if block_given?
      robot
    end
    
    def flags=(flags)
      flags.each do |f|
        send("#{f}=", true)
      end
    end

    def self.api_attr name, &init
      define_method "#{name}=" do |value|
        @@data_storage[Widget.get_unshared(@pointer).to_i][name] = value
      end

      init ||= proc{ nil }

      define_method name do
        @@data_storage[Widget.get_unshared(@pointer).to_i][name] ||= init.()
      end
    end


    def respond_to? name
      super || bang_respond_to?(name)
    end

    def method_missing name, *a, **na, &b
      if name.end_with? "!"
        bang_method_missing name, *a, **na, &b
      else super
      end
    end

    def self_cast_up widget, type = nil, equip: true
      return nil if widget.null?
      type = Widget.get_type widget if !type
      casted = Tgui.const_get(type).new pointer: widget
      equip_child_widget casted if equip
      casted
    end

    abi_static :get_type
    abi_static :get_unshared

    def self.finalizer pointer
      _abi_finalizer pointer
    end

    def self.api_child name, original_name = nil, &b
      if block_given?
        define_method "api_child_#{name}", &b
      else
        if original_name
          if original_name.end_with? "_"
            abi_name = "_abi_#{original_name}#{name}".delete_suffix("?").to_sym
          else
            abi_name = "_abi_#{original_name}".to_sym
          end
        else
          abi_name = "_abi_#{name}".delete_suffix("?").to_sym
        end
        define_method "api_child_#{name}" do |*a|
          send(abi_name, *a)
        end
      end
    end

    # internal

    def self_encode_position_layout value
      case value
      when String then value
      when Numeric then Unit.nominate value
      when :center then "(parent.innersize - size) / 2"
      when :begin then "0"
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
