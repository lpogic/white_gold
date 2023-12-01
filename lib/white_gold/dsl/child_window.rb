require_relative 'container'
require_relative 'signal/signal'

module Tgui
  class ChildWindow < Container

    class SignalClosing < Tgui::Signal
      def block_caller &b
        Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_VOIDP]) do |ptr|
          b.(ptr)
        end
      end
    end

    abi_enum "TitleAlignment", :left, :center, :right
    abi_bit_enum "TitleButtons", :none, :close, :maximize, :minimize, all: -1

    abi_attr :client_size, "SizeLayout"
    abi_attr :max_size, Vector2f, :maximum_size
    abi_attr :min_size, Vector2f, :minimum_size
    abi_attr :title, String
    abi_attr :title_size, Integer, :title_text_size
    abi_attr :title_alignment, TitleAlignment
    abi_attr :title_buttons, TitleButtons
    abi_attr :resizable?
    abi_attr :position_locked?
    abi_attr :keep_in_parent?

    def close destroy = false
      if destroy
        _abi_destroy
      else
        _abi_close
      end
    end

    abi_signal :on_mouse_press, Signal
    abi_signal :on_close, Signal
    abi_signal :on_maximize, Signal
    abi_signal :on_minimize, Signal
    abi_signal :on_escape_press, Signal
    abi_signal :on_closing, SignalClosing
    
  end
end