require_relative 'widget'

class Tgui
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
end