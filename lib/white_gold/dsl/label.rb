require_relative 'clickable_widget'
require_relative 'scrollbar'

module Tgui
  class Label < ClickableWidget

    abi_attr :text, String
    abi_attr :scrollbar_value, Integer
    abi_attr :auto_size?, "Boolean", :get_
    abi_attr :max_width, Integer, :maximum_text_width
    abi_def :ignore_mouse_events, "Boolean" => nil
    abi_def :ignore_mouse_events?, :ignoring_mouse_events, nil => "Boolean"
    abi_enum "HorizontalAlignment", :left, :center, :right
    abi_attr :horizontal_alignment, HorizontalAlignment
    abi_enum "VerticalAlignment", :top, :center, :bottom
    abi_attr :vertical_alignment, VerticalAlignment
    abi_enum Scrollbar::Policy
    abi_attr :scrollbar_policy, Scrollbar::Policy
    
  end
end