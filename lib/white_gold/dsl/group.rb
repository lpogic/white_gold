require_relative 'container'

class Tgui
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
end