require_relative '../extern_object'

class Tgui
  class BackendGui < ExternObject

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

    def view
      view = nil
      block_caller = Fiddle::Closure::BlockCaller.new(0, 
        [Fiddle::TYPE_FLOAT, Fiddle::TYPE_FLOAT, Fiddle::TYPE_FLOAT, Fiddle::TYPE_FLOAT]
      ) do |*a|
        view = a
      end
      Private.get_view @pointer, block_caller
      view
    end
  end
end