require_relative '../extern_object'
require_relative 'signal/signal'

module Tgui
  class BackendGui < ExternObject

    def view=(view)
      _abi_set_absolute_view *view
    end

    def relative_view=(view)
      _abi_set_relative_view *view
    end

    def view
      view = nil
      block_caller = Fiddle::Closure::BlockCaller.new(0,  Array.new(4, Fiddle::TYPE_FLOAT)) do |*a|
        view = a
      end
      _abi_get_view block_caller
      view
    end

    def viewport=(view)
      _abi_set_absolute_viewport *view
    end

    def relative_viewport=(view)
      _abi_set_relative_viewport *view
    end

    def viewport
      viewport = nil
      block_caller = Fiddle::Closure::BlockCaller.new(0,  Array.new(4, Fiddle::TYPE_FLOAT)) do |*a|
        viewport = a
      end
      _abi_get_viewport block_caller
      viewport
    end

    abi_alias :tab_focus_pass, :is_tab_key_usage_enabled
    abi_alias :tab_focus_pass=, :tab_key_usage_enabled

    def font=(font)
      _abi_set_font Font.produce(font)
    end

    abi_alias :font, :get_
    abi_alias :unfocus, :unfocus_all_widgets
    abi_attr :opacity
    abi_attr :text_size
    
    def push_mouse_cursor cursor
      _abi_set_override_mouse_cursor CursorType[cursor]
    end

    abi_alias :pop_mouse_cursor, :restore_override_mouse_cursor

    def px_to_crd px
      crd = nil
      block_caller = Fiddle::Closure::BlockCaller.new(0,  [Fiddle::TYPE_FLOAT, Fiddle::TYPE_FLOAT] ) do |*a|
        crd = a
      end
      _abi_map_pixel_to_coords px, block_caller
      crd
    end

    def crd_to_px crd
      px = nil
      block_caller = Fiddle::Closure::BlockCaller.new(0,  [Fiddle::TYPE_FLOAT, Fiddle::TYPE_FLOAT] ) do |*a|
        px = a
      end
      _abi_map_coords_to_pixel crd, block_caller
      px
    end

    abi_signal :on_view_change, Tgui::Signal
  end
end