require_relative 'clickable_widget'

class Tgui
  class EditBox < ClickableWidget
    Alignment = enum :left, :center, :right

    def alignment=(ali)
      Private.set_alignment(@pointer, Alignment[ali])
    end
    
    def alignment
      Alignment[Private.get_alignment @pointer]
    end
  end
end