require 'fiddle/import'
require_relative 'extension'
require_relative 'tgui-config'
require_relative 'extern_object'

class Tgui

  module Abi
    extend Fiddle::Importer
    
    begin
      Config::LIBS.each{ dlload _1 }
    rescue LoadError
      raise LoadError, 'Could not find shared library'
    end

    def self.call_arg_map! a
      a.map! do
        case _1
        when ExternObject then _1.pointer
        when true then 1
        when false then 0
        else _1
        end
      end
    end

    Vector2f = struct [
      'float x',
      'float y'
    ]
  end

  class Util < ExternObject
  end

  class Color < ExternObject
    def to_a
      [red, green, blue, alpha]
    end

    def inspect
      "##{to_a.map{ _1.to_s 16}.join}"
    end
  end

  class Signal < ExternObject

    def connect &b
      block_caller = Fiddle::Closure::BlockCaller.new(0, [0], &b)
      id = Private.connect(@pointer, block_caller)
      @@callback_storage[id] = block_caller
      return id
    end

    def disconnect id
      success = Private.disconnect(@pointer, id)
      @@callback_storage.delete(id) if success
      return success
    end

    def self.free_block_caller id
      @@callback_storage.delete(id)
    end
  end

  class Window < ExternObject
  end

  class Gui < ExternObject

    @@auto_name = "@/"

    def get name
      widget = Private.get_widget pointer, name.to_s
      return nil if widget.null?
      type = Widget.get_type widget
      Tgui.const_get(type).new pointer: widget
    end

    def []=(name, widget = nil)
      if widget
        add widget, name.to_s
      else 
        add widget, @@auto_name.next!
      end
    end

    def [](name)
      get name.to_s
    end

    def <<(widget)
      add widget, @@auto_name.next!
      self
    end
  end

  class Theme < ExternObject
    def self.default=(theme)
      self.set_default theme
    end
  end

  class Widget < ExternObject; end

  class ClickableWidget < Widget; end

  class ButtonBase < ClickableWidget
    def text_position=(text_position)
      position, origin = *text_position
      Private.set_text_position(@pointer, "(#{position[0]},#{position[1]})", "(#{origin[0]},#{origin[1]})")
    end
  end

  class Button < ButtonBase; end

  class EditBox < ClickableWidget
    Alignment = enum :left, :center, :right

    def alignment=(ali)
      Private.set_alignment(@pointer, Alignment[ali])
    end
    
    def alignment
      Alignment[Private.get_alignment @pointer]
    end
  end

  class Label < ClickableWidget
    HorizontalAlignment = enum :left, :center, :right

    def horizontal_alignment=(ali)
      Private.set_horizontal_alignment(@pointer, HorizontalAlignment[ali])
    end

    def horizontal_alignment
      HorizontalAlignment[Private.get_horizontal_alignment @pointer]
    end

    VerticalAlignment = enum :top, :center, :bottom

    def vertical_alignment=(ali)
      Private.set_vertical_alignment(@pointer, VerticalAlignment[ali])
    end

    def vertical_alignment
      VerticalAlignment[Private.get_vertical_alignment @pointer]
    end

    Policies = enum :auto, :always, :never

    def scrollbar_policy=(policy)
      Private.set_scrollbar_policy(@pointer, Policies[policy])
    end

    def scorllbar_policy
      Policies[Private.get_scrollbar_policy @pointer]
    end
  end

  class RadioButton < ClickableWidget; end

  class CheckBox < RadioButton; end

  class Container < Widget
    def get name
      widget = Private.get pointer, name.to_s
      return nil if widget.null?
      type = Widget.get_type widget
      Tgui.const_get(type).new pointer: widget
    end
  end

  class ChildWindow < Container
    TitleAlignment = enum :left, :center, :right

    def title_alignment=(alignment)
      Private.set_title_alignment(@pointer, TitleAlignment[alignment])
    end

    def title_alignment
      TitleAlignment[Private.get_title_alignment @pointer]
    end

    TitleButtons = bit_enum :none, :close, :maximize, :minimize, all: -1

    def title_buttons=(buttons)
      Private.set_title_buttons(@pointer,TitleButtons.pack(*buttons))
    end

    def title_buttons
      TitleButtons.unpack(Private.get_title_buttons @pointer)
    end
  end

  class Group < Container

    @@auto_name = "@/"

    def []=(name, widget)
      add widget, name.to_s
    end

    def [](name)
      get name
    end

    def <<(widget)
      add widget, @@auto_name.next!
      self
    end
  end

  class ColorPicker < ChildWindow
  end
end

# ABI loader should be required last
require_relative '../generated/tgui-abi-loader.gf'
