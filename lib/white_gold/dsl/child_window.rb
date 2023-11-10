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

    def client_size=(size)
      a = Array(size)
      w = self_encode_size_layout(a[0])
      h = self_encode_size_layout(a[1] || a[0])
      _abi_set_client_size w, h
    end

    def client_size
      vec = _abi_get_client_size
      [vec.x, vec.y]
    end

    abi_alias :max_size=, :set_maximum_size

    def max_size
      vec = _abi_get_maximum_size
      [vec.x, vec.y]
    end

    abi_alias :min_size=, :set_minimum_size

    def min_size
      vec = _abi_get_minimum_size
      [vec.x, vec.y]
    end

    abi_attr :title
    abi_attr :title_size, :title_text_size

    TitleAlignment = enum :left, :center, :right

    def title_alignment=(alignment)
      _abi_set_title_alignment TitleAlignment[alignment]
    end

    def title_alignment
      TitleAlignment[_abi_get_title_alignment]
    end

    TitleButtons = bit_enum :none, :close, :maximize, :minimize, all: -1

    def title_buttons=(buttons)
      _abi_set_title_buttons TitleButtons.pack(*buttons)
    end

    def title_buttons
      TitleButtons.unpack(_abi_get_title_buttons)
    end

    def close destroy = false
      if destroy
        _abi_destroy
      else
        _abi_close
      end
    end

    abi_attr :resizable?
    abi_attr :position_locked?
    abi_attr :keep_in_parent?
    abi_signal :on_mouse_press, Signal
    abi_signal :on_close, Signal
    abi_signal :on_maximize, Signal
    abi_signal :on_minimize, Signal
    abi_signal :on_escape_press, Signal
    abi_signal :on_closing, SignalClosing
  end
end