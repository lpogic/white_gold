require_relative '../abi/extern_object'
require_relative 'signal/signal_bool'
require_relative 'signal/global_signal'
require_relative 'font'

module Tgui
  class BackendGui < ExternObject
    include Extree

    class ViewSignal < GlobalSignal
      def block_caller &b
        Fiddle::Closure::BlockCaller.new(0, [0]) do
            b.(@widget.view, @widget)
        end
      end
    end

    abi_def :view=, :set_absolute_, [Integer] * 4 => nil
    abi_def :relative_view=, [Float] * 4 => nil
    abi_def :view, :get_, nil => [Float] * 4
    abi_def :viewport=, :set_absolute_, [Integer] * 4 => nil
    abi_def :viewport, :get_, nil => [Float] * 4
    abi_def :relative_viewport=, [Float] * 4 => nil
    abi_attr :tab_focus_enabled?, Boolean, :tab_key_usage_enabled
    abi_attr :font, Font
    abi_def :unfocus, :unfocus_all_widgets
    abi_attr :opacity, Float
    abi_attr :text_size, Integer
    abi_def :push_mouse_cursor, :set_override_mouse_cursor, CursorType => nil
    abi_def :pop_mouse_cursor, :restore_override_mouse_cursor
    abi_def :px_to_crd, :map_pixel_to_coords, [Integer, Integer] => [Float, Float]
    abi_def :crd_to_px, :map_coords_to_pixel, [Float, Float] => [Float, Float]
    abi_attr :keyboard_navigation?, Boolean, :keyboard_navigation_enabled
    abi_signal :on_view_change, ViewSignal
    abi_signal :on_focus, Signal, :on_window_focus
    abi_signal :on_unfocus, Signal, :on_window_unfocus
    
  end
end