require_relative 'container'

class Tgui
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
end