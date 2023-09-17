require_relative 'group'

class Tgui
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
end