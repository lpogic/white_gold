require_relative 'button'
require_relative 'signal/signal_string'
require_relative '../convention/widget_like'

module Tgui
  class MessageBox < ChildWindow

    api_attr :format do
      :to_s
    end

    abi_enum "Alignment", :left, :center, :right
    abi_attr :button_alignment, Alignment
    abi_attr :label_alignment, Alignment
    abi_attr :text, String

    def initialized
      on_button_press do |button, widget|
        self_buttons[button]&.press_signal_execute
      end
    end

    class Button < WidgetLike
      def initialize host, id
        super
        @on_press_callbacks = []
      end

      def on_press=(on_press)
        @on_press_callbacks << on_press.to_proc
      end

      def press_signal_execute
        host.page.upon! host do
          @on_press_callbacks.each do |c|
            c.(id, self, host)
          end
        end
      end
    end


    api_def :button do |object, text: nil, **na, &b|
      text ||= object.then(&format)
      raise "Button with given text exists (#{text})" if self_buttons[text]
      _abi_add_button abi_pack_string(text)
      button = Button.new self, object
      self_buttons[text] = button
      upon! button, **na, &b
    end

    def [](object)
      self_buttons.values.find{ _1.id == object }
    end

    def remove_buttons
      self.buttons = {}
    end

    def buttons=(buttons)
      self.self_buttons = {}
      names = buttons.map do |object, on_press|
        text = object.then(&format)
        raise "Button with given text exists (#{text})" if self_buttons[text]
        button = Button.new self, object
        button.on_press = on_press
        self_buttons[text] = button
        text
      end
      self_change_buttons names
    end

    def buttons
      self_buttons.values.map{ _1.id }
    end

    abi_signal :on_button_press, SignalString

    #internal

    abi_def :self_change_buttons, :change_buttons, String.. => nil

    api_attr :self_buttons do
      {}
    end
  end
end