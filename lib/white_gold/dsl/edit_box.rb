require_relative 'clickable_widget'
require_relative 'signal/signal_string'
require_relative 'signal/signal_typed_size_t'

module Tgui
  class EditBox < ClickableWidget

    Alignment = enum :left, :center, :right

    abi_attr :default_text
    abi_alias :select_text
    abi_alias :selected_text, :get_
    abi_attr :password_character
    abi_attr :characters_limit, :maximum_characters
    abi_alias :limited_text_width=, :limit_text_width
    abi_alias :limited_text_width?, :is_text_width_limited
    abi_attr :read_only?
    abi_attr :caret_position
    abi_attr :suffix
    abi_signal :on_text_change, SignalString
    abi_signal :on_return_key_press, SignalString
    abi_signal :on_return_or_unfocus, SignalString
    abi_signal :on_caret_position_change, SignalTypedSizeT

    def text=(object)
      _abi_set_text object.to_s
    end

    abi_alias :text, :get_

    def alignment=(ali)
      _abi_set_alignment Alignment[ali]
    end
    
    def alignment
      Alignment[_abi_get_alignment]
    end
  end
end