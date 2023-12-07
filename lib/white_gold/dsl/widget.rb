require_relative '../abi/extern_object'
require_relative '../convention/bang_nested_caller'
require_relative '../convention/unit'
require_relative '../convention/widget_like'
require_relative 'color'
require_relative 'outline'
require_relative 'texture'
require_relative 'signal/signal'
require_relative 'signal/signal_vector2f'
require_relative 'signal/signal_show_effect'
require_relative 'signal/signal_animation_type'
require_relative 'tool_tip'

module Tgui
  class Widget < ExternObject
    include BangNestedCaller
    extend ApiDef

    attr_accessor :page

    abi_attr :text_size, Integer
    abi_attr :enabled?

    api_def :disabled do |disabled = true|
      self.enabled = !disabled
    end

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
    abi_attr :position, "PositionLayout"
    abi_def :absolute_position, :get_, nil => "PositionLayout"
    abi_attr :size, "SizeLayout"
    abi_def :full_size, :get_, nil => "SizeLayout"
    abi_def :height=, :set_, "SingleSizeLayout" => nil

    def height
      size[1]
    end

    abi_def :width=, :set_, "SingleSizeLayout" => nil

    def width
      size[0]
    end

    abi_def :can_gain_focus?, :can_gain_focus, nil => "Boolean"
    abi_def :container?, nil => "Boolean"

    api_def :tooltip do |*a, **na, &b|
      if block_given?
        tooltip = ToolTip.new
        tooltip.page = page
        upon! tooltip, **na, &b
        _abi_set_tool_tip tooltip.widget if tooltip.widget
      else
        widget = _abi_get_tool_tip
        return nil if widget.null?
        tooltip = ToolTip.new
        tooltip.widget = widget
        return tooltip
      end
    end

    abi_attr :mouse_cursor, CursorType
    abi_def :draggable?, :is_widget_, nil => "Boolean"
    abi_def :mouse_down?, nil => "Boolean"

    abi_enum "ShowEffectType", :fade, :scale, :slide_to_right, :slide_to_left, :slide_to_bottom,
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
        _abi_set_visible abi_pack_boolean(a)
      end
    end

    abi_def :visible?, nil => "Boolean"

    def show effect = nil, duration = 1000
      if effect
        _abi_show_with_effect abi_pack(ShowEffectType, effect), abi_pack_integer(duration)
      else
        _abi_set_visible 1
      end
    end

    def hide effect = nil, duration = 1000
      if effect
        _abi_hide_with_effect abi_pack(ShowEffectType, effect), abi_pack_integer(duration)
      else
        _abi_set_visible 0
      end
    end

    def pack_animation_time o
      o ? o.to_i : 1000
    end

    abi_def :move, :move_with_animation, ["SizeLayout", :pack_animation_time] => nil
    abi_def :resize, :resize_with_animation, ["PositionLayout", :pack_animation_time] => nil

    abi_enum "AnimationType", :move, :resize, :opacity

    abi_def :finish_animations, :finish_all_animations
    abi_def :front, :move_to_
    abi_def :back, :move_to_

    abi_enum "KeyCode", nil, :a, :b, :c, :d, :e, :f, :g, :h, :i, :j, :k, 
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
        super(widget, nil)
      end

      abi_def :mouse_move, :mouse_moved, [Float, Float] => nil

      def mouse_press x, y, down: false
        host._abi_left_mouse_pressed abi_pack_float(x), abi_pack_float(y)
        mouse_release x, y if !down
      end

      abi_def :mouse_release, :left_mouse_released, [Float, Float] => nil
      abi_def :right_mouse_press, :right_mouse_pressed, [Float, Float] => nil
      abi_def :right_mouse_release, :right_mouse_released, [Float, Float] => nil

      def key_press key, alt: false, control: false, shift: false, system: false
        host._abi_key_pressed abi_pack(KeyCode, key), 
          abi_pack_boolean(alt), 
          abi_pack_boolean(control), 
          abi_pack_boolean(shift), 
          abi_pack_boolean(system)
      end

      def text text
        text.each_codepoint do |cp|
          host._abi_text_entered abi_pack_integer(cp)
        end
      end

      def scroll delta, x, y, touch = false
        host._abi_scrolled abi_pack_float(delta), abi_pack_float(x), abi_pack_float(y), abi_pack_boolean(touch)
      end

      abi_def :tooltip, :ask_toop_tip, [Float, Float] => nil
    end

    api_def :robot do |**na, &b|
      robot = Robot.new self
      upon! robot, **na, &b if block_given?
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
      type = abi_unpack_string(Widget.get_type widget) if !type
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
            abi_name = "_abi_#{original_name}#{name}".delete_suffix("=").delete_suffix("?").to_sym
          else
            abi_name = "_abi_#{original_name}".to_sym
          end
        else
          if name.end_with? "?"
            abi_name = "_abi_is_#{name}".delete_suffix("?").to_sym
          elsif name.end_with? "="
            abi_name = "_abi_set_#{name}".delete_suffix("=").to_sym
          else
            abi_name = "_abi_#{name}".to_sym
          end
        end
        define_method "api_child_#{name}" do |*a|
          send(abi_name, *a)
        end
      end
    end

    @@renderer_property_types = {
      Color => [:_abi_set_color_renderer_property, :_abi_get_color_renderer_property],
      String => [:_abi_set_string_renderer_property, :_abi_get_string_renderer_property],
      Font => [:_abi_set_font_renderer_property, :_abi_get_font_renderer_property],
      "Boolean" => [:_abi_set_boolean_renderer_property, :_abi_get_boolean_renderer_property],
      Float => [:_abi_set_float_renderer_property, :_abi_get_float_renderer_property],
      Outline => [:_abi_set_outline_renderer_property, :_abi_get_outline_renderer_property],
      Texture => [:_abi_set_texture_renderer_property, :_abi_get_texture_renderer_property],
      TextStyles => [:_abi_set_text_styles_renderer_property, :_abi_get_text_styles_renderer_property],
    }

    def self.renderer_property_types
      @@renderer_property_types
    end

    def self.abi_render_attr name, type, original_name = nil
      property_name = original_name || name
      property_name = property_name.to_s.pascalcase if !property_name.is_a? String
      property_methods = renderer_property_types[type]
      raise "Unknown property type #{type}" if !property_methods

      interface = Interface.from [Object, type], nil
      self_abi_def_setter "#{name}=".to_sym, property_methods[0], interface, property_name
      
      interface = Interface.from nil, type
      self_abi_def name.to_sym, property_methods[1], interface, property_name
    end
  end
end
