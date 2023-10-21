require_relative 'widget'

module Tgui
  class Container < Widget

    abi_alias :add

    def get a
      case a
      when Widget then a
      else
        widget = _abi_get a.to_s
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
      _abi_get_widgets block_caller
      return widgets
    end
  end
end