require_relative '../extern_object'

class Tgui
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
end