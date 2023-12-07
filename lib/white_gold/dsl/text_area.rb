require_relative 'widget'
require_relative 'signal/signal'
require_relative 'signal/signal_string'

module Tgui
  class TextArea < Widget

    abi_attr :text, String
    abi_def :add_text, String => nil
    abi_attr :default_text, String
    abi_def :selected_text=, :set_, Range => nil
    abi_def :selected_text, :get_, nil => String
    abi_def :selection_start, :get_, nil => Integer
    abi_def :selection_end, :get_, nil => Integer
    abi_def :text_limit, :maximum_characters, nil => Integer
    abi_attr :tab_string, String
    abi_attr :caret_position, Integer
    abi_def :caret_line, nil => Integer
    abi_def :caret_column, nil => Integer
    abi_attr :read_only?
    abi_enum Scrollbar::Policy
    abi_attr :vertical_scrollbar_policy, Scrollbar::Policy
    abi_attr :horizontal_scrollbar_policy, Scrollbar::Policy
    abi_attr :vertical_scrollbar_value, Integer
    abi_attr :horizontal_scrollbar_value, Integer
    abi_def :lines_count, nil => Integer
    abi_def :monospace_boost=, :set_monospace_font_optimization, "Boolean" => nil
    abi_signal :on_text_change, SignalString
    abi_signal :on_selection_change, Signal
    abi_signal :on_caret_change, Signal, :on_caret_position_change

    abi_render_attr :borders, Outline
    abi_render_attr :padding, Outline
    abi_render_attr :background_color, Color
    abi_render_attr :text_color, Color
    abi_render_attr :default_text_color, Color
    abi_render_attr :selected_text_color, Color
    abi_render_attr :selected_text_background_color, Color
    abi_render_attr :border_color, Color
    abi_render_attr :caret_color, Color
    abi_render_attr :texture_background, Texture
    # abi_render_attr :scrollbar
    abi_render_attr :scrollbar_width, Float
  end
end