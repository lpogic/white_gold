require_relative '../abi/extern_object'
require_relative '../convention/unit'
require_relative '../convention/widget_like'
require_relative '../convention/api_child'
require_relative '../convention/theme/theme_component'
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
    include Extree

    class Theme < ThemeComponent
    
      theme_attr :opacity, :float
      theme_attr :opacity_disabled, :float
      theme_attr :text_size, :float
      theme_attr :transparent_texture, :boolean
  
    end

    attr_accessor :page

    def window
      page.window
    end

    abi_attr :text_size, Integer
    abi_attr :enabled?

    def! :disabled do |disabled = true|
      self.enabled = !disabled
    end

    def! :theme do |seed = VOID, **na, &b|
      seed = page.custom_renderers[self] if seed == VOID
      if !na.empty? || b
        if seed.is_a?(String) && seed =~ /_\d+/
          page.theme.attributes[seed].host! **na, &b
          page.theme.self_commit
        else
          seed = page.theme.custom! self.class::Theme, seed, **na, &b
          page.custom_renderers[self] = seed
        end
      elsif seed
        page.custom_renderers[self] = seed
      end
      self_set_renderer seed
    end

    def theme=(theme)
      case theme
      when Hash
        send! :theme, **theme
      when Proc
        send! :theme, &theme
      else
        page.custom_renderers[self] = theme
        self_set_renderer theme
      end
    end

    abi_def :self_set_renderer, :set_renderer, proc.self_theme_name => nil
    
    abi_attr :focused?
    def! :focus do |focus = VOID|
      self.focused = focus
    end
    def! :unfocus do
      self.focused = false
    end
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

    abi_enum "AutoLayout", :disabled, :top, :left, :right, :bottom, :leftmost, :rightmost, :fill

    abi_attr :auto_layout, AutoLayout
    abi_def :can_gain_focus?, :can_gain_focus, nil => Boolean
    abi_def :container?, nil => Boolean

    def! :tooltip do |*a, **na, &b|
      if block_given?
        tooltip = ToolTip.new
        tooltip.page = page
        scope! tooltip, **na, &b
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
    abi_def :draggable?, :is_widget_, nil => Boolean
    abi_def :mouse_down?, nil => Boolean
    abi_attr :ignore_mouse_events?, Boolean, :get_

    abi_enum "ShowEffectType", :fade, :scale, :slide_to_right, :slide_to_left, :slide_to_bottom,
    :slide_to_top, slide_from_left: :slide_to_right, slide_from_right: :slide_to_left,
    slide_from_top: :slide_to_bottom, slide_from_bottom: :slide_to_top

    def visible=(a = true)
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

    abi_def :visible?, nil => Boolean

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

    def self_pack_animation_time o
      o ? o.to_i : 1000
    end

    abi_def :move, :move_with_animation, ["SizeLayout", :self_pack_animation_time] => nil
    abi_def :resize, :resize_with_animation, ["PositionLayout", :self_pack_animation_time] => nil

    abi_enum "AnimationType", :move, :resize, :opacity

    abi_def :finish_animations, :finish_all_animations
    abi_def :front, :move_to_
    abi_def :back, :move_to_

    class Navigation < WidgetLike

      def left=(widget)
        host._abi_set_navigation host.abi_pack(Widget, widget), host.abi_pack_integer(0)
      end

      def left
        abi_unpack(Widget, host._abi_get_navigation(host.abi_pack_integer(0)))
      end

      def right=(widget)
        host._abi_set_navigation host.abi_pack(Widget, widget), host.abi_pack_integer(1)
      end

      def right
        host.abi_unpack(Widget, host._abi_get_navigation(host.abi_pack_integer(1)))
      end

      def up=(widget)
        host._abi_set_navigation host.abi_pack(Widget, widget), host.abi_pack_integer(2)
      end

      def up
        host.abi_unpack(Widget, host._abi_get_navigation(host.abi_pack_integer(2)))
      end

      def down=(widget)
        host._abi_set_navigation host.abi_pack(Widget, widget), host.abi_pack_integer(3)
      end

      def down
        host.abi_unpack(Widget, host._abi_get_navigation(host.abi_pack_integer(3)))
      end

    end

    def! :navigation do |**na, &b|
      scope! navigation, **na, &b
    end

    def navigation
      Navigation.new self, nil
    end

    abi_enum "KeyCode", :a, :b, :c, :d, :e, :f, :g, :h, :i, :j, :k, 
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

    def! :robot do |**na, &b|
      robot = Robot.new self
      scope! robot, **na, &b if block_given?
      robot
    end

    def! :messagebox do |*a, **na, &b|
      page.send! :messagebox, *a, **na, &b
    end

    def! :msg do |text, **buttons|
      buttons["OK"] = nil if buttons.empty?
      buttons = buttons.map do |k, v| 
        procedure = proc do |o, b, w|
          v&.call
          w.close true
        end
        [k, procedure]
      end
      page.send! :messagebox, text:, position: :center, label_alignment: :center, buttons: buttons
    end

    def! :page do |*a, **na, &b|
      page.host! *a, **na, &b
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

    def self_cast_up widget, type = nil, equip: true
      return nil if widget.null?
      type = abi_unpack_string(Widget.get_type widget) if !type
      casted = Tgui.const_get(type).new pointer: widget
      self_equip_child_widget casted if equip
      casted
    end

    abi_packer Widget do |o|
      o = o.first if o.is_a? Array
      case o
      when Widget
        o
      else
        raise "Unable to make Widget from #{o}(#{o.class})"
      end
    end

    abi_unpacker Widget do |o|
      self_cast_up o
    end

    abi_static :get_type
    abi_static :get_unshared

    class << self
      include ApiChild

      def self_theme_name widget, theme = nil
        case theme
        when Module
          theme.name.split("::").last
        when nil, false, VOID
          self_theme_name widget, widget.class
        else
          theme.to_s
        end
      end

      def finalizer pointer
        _abi_finalizer pointer
      end
    end
  end
end
