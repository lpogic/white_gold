require_relative 'button'
require_relative 'signal/signal_string'
require_relative '../convention/widget_like'

module Tgui
  class MessageBox < ChildWindow
    Alignment = enum :left, :center, :right

    def button_alignment=(ali)
      _abi_set_button_alignment Alignment[ali]
    end
    
    def button_alignment
      Alignment[_abi_get_button_alignment]
    end

    def label_alignment=(ali)
      _abi_set_label_alignment Alignment[ali]
    end
    
    def label_alignment
      Alignment[_abi_get_label_alignment]
    end

    abi_attr :text

    def initialized
      on_button_press do |button, widget|
        self_buttons[button]&.each{ _1.call(widget) }
      end
    end

    api_attr :self_buttons do
      {}
    end

    class Button < WidgetLike
      def initialize message_box, text
        @message_box = message_box
        @text = text
      end

      def on_press=(on_press)
        @message_box.self_buttons[@text] << on_press.to_proc
      end
    end


    def button text:, **na, &b
      _abi_add_button text
      self_buttons[text] = []
      button = Button.new self, text
      bang_nest button, **na, &b
    end

    def [](text)
      Button.new self, text
    end

    def remove_buttons
      self.buttons = {}
    end

    def buttons=(buttons)
      self.self_buttons = {}
      it = buttons.each
      block_caller = Fiddle::Closure::BlockCaller.new(Fiddle::TYPE_CONST_STRING, [0]) do
        key, action = it.next
        name = key.to_s
        (self_buttons[name] ||= []) << action
        name
      rescue StopIteration
        ""
      end
      _abi_change_buttons buttons.size, block_caller
    end

    def buttons
      self_buttons.keys
    end

    abi_signal :on_button_press, SignalString
  end
end