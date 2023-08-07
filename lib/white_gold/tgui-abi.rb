require 'fiddle/import'
require_relative 'path/fiddle-pointer.path'
require_relative 'tgui-config'
require_relative 'extern_object'
require_relative 'extern_enum'

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

  ShowEffectType = enum :fade, :scale, :slide_to_right, :slide_to_left, :slide_to_bottom,
    :slide_to_top, slide_from_left: :slide_to_right, slide_from_right: :slide_to_left,
    slide_from_top: :slide_to_bottom, slide_from_bottom: :slide_to_top

  AnimationType = enum :move, :resize, :opacity

  TextStyle = bit_enum :regular, :bold, :italic, :underlined, :strike_through

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

  class SignalBool < Signal
    def connect &b
      block_caller = Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_INT]) do |int|
        b.(int.odd?)
      end
      id = Private.connect(@pointer, block_caller)
      @@callback_storage[id] = block_caller
      return id
    end
  end

  class SignalString < Signal
    def connect &b
      block_caller = Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_VOIDP]) do |str|
        b.(str.parse('char32_t'))
      end
      id = Private.connect(@pointer, block_caller)
      @@callback_storage[id] = block_caller
      return id
    end
  end

  class SignalColor < Signal
    def connect &b
      block_caller = Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_VOIDP]) do |ptr|
        b.(ptr.parse('Color'))
      end
      id = Private.connect(@pointer, block_caller)
      @@callback_storage[id] = block_caller
      return id
    end
  end

  class SignalPointer < Signal
    def connect &b
      block_caller = Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_VOIDP], &b)
      id = Private.connect(@pointer, block_caller)
      @@callback_storage[id] = block_caller
      return id
    end
  end

  class SignalVector2f < Signal
    def connect &b
      block_caller = Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_VOIDP]) do |ptr|
        b.(ptr.parse('Vector2f'))
      end
      id = Private.connect(@pointer, block_caller)
      @@callback_storage[id] = block_caller
      return id
    end
  end

  class SignalShowEffect < Signal
    def connect &b
      block_caller = Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_INT, Fiddle::TYPE_INT]) do |show_effect_type, shown|
        b.(ShowEffectType[int], shown.odd?)
      end
      id = Private.connect(@pointer, block_caller)
      @@callback_storage[id] = block_caller
      return id
    end
  end

  class SignalAnimationType < Signal
    def connect &b
      block_caller = Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_INT]) do |animation_type|
        b.(AnimationType[animation_type])
      end
      id = Private.connect(@pointer, block_caller)
      @@callback_storage[id] = block_caller
      return id
    end
  end

  class SignalItem < Signal
    def connect &b
      block_caller = Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP]) do |str1, str2|
        b.(str1.parse('char32_t'), str2.parse('char32_t'))
      end
      id = Private.connect(@pointer, block_caller)
      @@callback_storage[id] = block_caller
      return id
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

  class Widget < ExternObject

    def respond_to? name
      super || name.start_with?("_")
    end

    def method_missing name, *a, **na, &b
      if name.start_with? "_"
        if name.end_with? "="
          @@data_storage[Widget.get_unshared(@pointer).to_i][name[...-1]] = a[0]
        else
          @@data_storage[Widget.get_unshared(@pointer).to_i][name.to_s]
        end
      else
        super
      end
    end
  end

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
    def get a
      case a
      when Widget then a
      else
        widget = Private.get pointer, a.to_s
        return nil if widget.null?
        type = Widget.get_type widget
        Tgui.const_get(type).new pointer: widget
      end
    end

    def get_widgets
      widgets = []
      block_caller = Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP]) do |pointer, type|
        widgets << Tgui.const_get(type.utf32_to_s).new(pointer:)
      end
      Private.get_widgets @pointer, block_caller
      return widgets
    end

    def [](name)
      get name
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

    def <<(widget)
      add widget, @@auto_name.next!
      self
    end
  end

  class BoxLayout < Group
    def get i
      if Integer === i
        widget = Private.get_by_index pointer, i
        return nil if widget.null?
        type = Widget.get_type widget
        Tgui.const_get(type).new pointer: widget
      else
        super i
      end
    end

    def []=(*a)
      if a.size == 1
        add a[0], @@auto_name.next!
      elsif a.size == 2
        if Integer === a[0]
          insert a[0], a[1], @@auto_name.next!
        else
          add a[0], a[1].to_s
        end
      else
        insert a[0], a[1], a[2].to_s
      end
    end

    def remove i
      if Integer === i
        Private.remove_by_index(pointer, i).odd?
      else
        super i
      end
    end
  end

  class BoxLayoutRatios < BoxLayout
    class Ratios
      def initialize box
        @box = box
      end

      def [](i)
        case i
        when Integer
          Private.get_ratio_by_index @box, i, ratio
        when Widget
          Private.get_ratio @box, i, ratio
        else
          i = @box.get i
          Private.get_ratio @box, i, ratio
        end
      end

      def []=(i, ratio)
        case i
        when Integer
          Private.set_ratio_by_index @box, i, ratio
        when Widget
          Private.set_ratio @box, i, ratio
        else
          i = @box.get i
          Private.set_ratio @box, i, ratio
        end
      end
    end

    def ratio
      Ratios.new self
    end
  end

  class HorizontalLayout < BoxLayoutRatios
  end

  class VerticalLayout < BoxLayoutRatios
  end

  class HorizontalWrap < BoxLayout
  end

  class RadioButtonGroup < Container
  end

  class Panel < Group
  end

  class ScrollablePanel < Panel
  end

  class Grid < Container
    Alignment = enum :center, :upper_left, :up, :upper_right, :right, :bottom_right, :botton, :bottom_left, :left
    
    class PaddingAttr
      def initialize grid
        @grid = grid
      end

      def [](*a)
        widget = @grid.get *a
        Private.get_widget_padding @grid, widget if widget
      end

      def []=(*a, value)
        widget = @grid.get *a
        Private.set_widget_padding @grid, widget, *value_to_padding(value) if widget
      end

      def value_to_padding v
        if !v
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
      end
    end

    class AlignmentAttr
      def initialize grid
        @grid = grid
      end

      def [](*a)
        widget = @grid.get *a
        Alignment[Private.get_widget_alignment @grid, widget] if widget
      end

      def []=(*a, value)
        widget = @grid.get *a
        Private.set_widget_padding @grid, widget, Alignment[value] if widget
      end
    end

    class CellAttr
      def initialize grid
        @grid = grid
      end

      def []=(*a, value)
        widget = @grid.get *a
        Private.set_widget_cell @grid, widget, *value if widget
      end
    end

    def initialized
      super
      @current_row = 0
      @current_column = 0
    end

    def padding
      PaddingAttr.new self
    end

    def alignment
      AlignmentAttr.new self
    end

    def cell
      CellAttr.new self
    end

    def get *a
      case a.size
      when 1 then super *a
      when 2 then Private.get_widget @pointer, *a
      else nil
      end
    end

    def add widget, name = nil
      super
      Private.set_widget_cell @pointer, widget, @current_row, @current_column
      @current_column += 1
    end

    def next_row
      @current_column = 0
      @current_row += 1
    end
  end

  class ComboBox < Widget
    ExpandDirection = enum :up, :down, :auto

    @@auto_id = "@/"

    def selected=(item)
      case item
      when nil, false then deselect_item
      when Integer then Private.set_selected_item_by_index @pointer, item
      else Private.set_selected_item_by_id @pointer, item.to_s
      end
    end

    def selected
      return Private.get_selected_item_id @pointer
    end

    def remove(item)
      case item
      when Integer then Private.remove_item_by_index @pointer, item
      else Private.remove_item_by_id @pointe, item.to_s
      end
    end

    def [](item)
      case item
      when Integer
        Private.get_item_by_id(@pointer, get_item_ids[item])
      else
        Private.get_item_by_id @pointer, item.to_s
      end
    end

    def items
      ids = []
      block_caller = Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_VOIDP]) do |id|
        ids << ids.utf32_to_s
      end
      Private.get_item_ids @pointer, block_caller
      return ids
    end

    def contains?(id)
      Private.contains_id @pointer, id.to_s
    end

    def []=(item, value)
      case item
      when Integer
        if item < item_count
          Private.change_item_by_index @pointer, item, value
        else
          add_item value, @@auto_id.next!
        end
      else
        id = item.to_s
        if Private.contains_id @pointer, id
          Private.change_item_by_id @pointer, id, value
        else
          add_item value, id
        end
      end
    end

    def items=(items)
      remove_all_items
      items = items.map{ [_1, _1] }.to_h if Array === items
      items.each do |id, value|
        self[id] = value
      end
    end
    
  end

  class ColorPicker < ChildWindow
  end
end

# ABI loader should be required last
require_relative '../generated/tgui-abi-loader.gf'
