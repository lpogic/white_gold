require_relative 'container'

module Tgui
  class ChildWindow < Container
    TitleAlignment = enum :left, :center, :right

    def title_alignment=(alignment)
      _abi_set_title_alignment(@pointer, TitleAlignment[alignment])
    end

    def title_alignment
      TitleAlignment[_abi_get_title_alignment @pointer]
    end

    TitleButtons = bit_enum :none, :close, :maximize, :minimize, all: -1

    def title_buttons=(buttons)
      _abi_set_title_buttons(@pointer,TitleButtons.pack(*buttons))
    end

    def title_buttons
      TitleButtons.unpack(_abi_get_title_buttons @pointer)
    end

    def client_size=(size)
      size[0] = @@value_unitizer.(size[0])
      size[1] = @@value_unitizer.(size[1])
      _abi_set_client_size @pointer, *size
    end
  end
end