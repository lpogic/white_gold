require_relative 'widget'
require_relative 'signal/signal'
require_relative 'signal/signal_string'

module Tgui
  class TextArea < Widget

    abi_attr :text
    abi_alias :add_text
    abi_attr :default_text
    abi_attr :selected_text
    abi_alias :selection_start, :get_
    abi_alias :selection_end, :get_
    abi_alias :text_limit, :maximum_characters
    abi_attr :tab_string
    abi_attr :caret_position
    abi_alias :caret_line
    abi_alias :caret_column
    abi_attr :read_only?

    def vertical_scrollbar_policy=(policy)
      _abi_set_vertical_scrollbar_policy Scrollbar::Policy[policy]
    end

    def vertical_scrollbar_policy
      Scrollbar::Policy[_abi_get_vertical_scrollbar_policy]
    end

    def horizontal_scrollbar_policy=(policy)
      _abi_set_horizontal_scrollbar_policy Scrollbar::Policy[policy]
    end

    def horizontal_scrollbar_policy
      Scrollbar::Policy[_abi_get_horizontal_scrollbar_policy]
    end

    abi_attr :vertical_scrollbar_value
    abi_attr :horizontal_scrollbar_value
    abi_alias :lines_count
    abi_alias :monospace_boost=, :set_monospace_font_optimization

    abi_signal :on_text_change, SignalString
    abi_signal :on_selection_change, Signal
    abi_signal :on_caret_change, Signal, :on_caret_position_change
  end
end