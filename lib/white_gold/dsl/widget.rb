require_relative '../extern_object'
require_relative '../convention/bang_nested_caller'
require_relative 'signal'
require_relative 'signal_vector2f'
require_relative 'signal_show_effect'
require_relative 'signal_animation_type'

module Tgui
  class Widget < ExternObject
    include BangNestedCaller

    abi_attr :text_size
    abi_attr :visible?
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

    def width=(width)
      w = self_encode_size_layout(width)
      _abi_set_width w
    end

    abi_alias :can_gain_focus?
    abi_alias :container?, :is_
    
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

    def self.default_unit=(unit)
      case unit
      when :pixel, :px
        @@number_to_layout = proc{|number| number.px }
      when :percent, :pc
        @@number_to_layout = proc{|number| number.pc }
      else raise "Ivalid unit given (:px/:pixel/:pc/:percent allowed)"
      end
    end

    self.default_unit = :px

    # internal

    def self_encode_position_layout value
      case value
      when String then value
      when Numeric then @@number_to_layout.(value)
      when :center then "(parent.innersize - size) / 2"
      when :begin then "size / 2"
      when :end then "parent.innersize - size / 2"
      else raise "Invalid value `#{value}` given"
      end
    end    

    def self_encode_size_layout value
      case value
      when String then value
      when Numeric then @@number_to_layout.(value)
      when :full then "100%"
      when :half then "50%"
      when :third then "parent.innersize  / 3"
      when :quarter then "25%"
      else raise "Invalid value `#{value}` given"
      end
    end

    attr_accessor :page
  end
end