require_relative 'clickable_widget'

module Tgui
  class EditBox < ClickableWidget
    Alignment = enum :left, :center, :right

    def text=(object)
      _abi_set_text object.to_s
    end

    abi_alias :text, :get_

    def alignment=(ali)
      _abi_set_alignment(@pointer, Alignment[ali])
    end
    
    def alignment
      Alignment[_abi_get_alignment @pointer]
    end
  end
end