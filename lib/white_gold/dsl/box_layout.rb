require_relative 'group'

module Tgui
  class BoxLayout < Group
    def get i
      if Integer === i
        widget = _abi_get_by_index pointer, i
        return nil if widget.null?
        type = Widget.get_type widget
        Tgui.const_get(type).new pointer: widget
      else
        super i
      end
    end

    def []=(*a)
      raise "TODO"
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
        _abi_remove_by_index(pointer, i).odd?
      else
        super i
      end
    end
  end
end