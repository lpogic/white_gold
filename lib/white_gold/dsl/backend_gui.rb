require_relative '../abi/extern_object'
require_relative 'signal/signal'
require_relative 'font'

module Tgui
  class BackendGui < ExternObject

    abi_def :view=, :set_absolute_, [Integer] * 4 => nil
    abi_def :relative_view=, [Float] * 4 => nil
    abi_def :view, nil => [Float] * 4
    abi_def :viewport=, :set_absolute_, [Integer] * 4 => nil
    abi_def :viewport, nil => [Float] * 4
    abi_def :relative_viewport=, [Float] * 4 => nil
    abi_def :tab_focus_pass?, :is_tab_key_usage_enabled, nil => "Boolean"
    abi_def :tab_focus_pass=, :tab_key_usage_enabled, "Boolean" => nil
    abi_attr :font, Font
    abi_def :unfocus, :unfocus_all_widgets
    abi_attr :opacity, Float
    abi_attr :text_size, Integer
    abi_def :push_mouse_cursor, :set_override_mouse_cursor, CursorType => nil
    abi_def :pop_mouse_cursor, :restore_override_mouse_cursor
    abi_def :px_to_crd, :map_pixel_to_coords, [Integer, Integer] => [Float, Float]
    abi_def :crd_to_px, :map_coords_to_pixel, [Float, Float] => [Float, Float]
    abi_signal :on_view_change, Signal
    
  end
end