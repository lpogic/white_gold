require_relative 'button'

class Tgui
  class MessageBox < ChildWindow
    Alignment = enum :left, :center, :right

    def button_alignment=(ali)
      Private.set_button_alignment(@pointer, Alignment[ali])
    end
    
    def button_alignment
      Alignment[Private.get_button_alignment @pointer]
    end

    def initialized
      @button_press_callbacks = {}
      on_button_press do |button|
        @button_press_callbacks[button]&.each{ _1.call }
      end
    end

    def button(text:, on_press: nil)
      (@button_press_callbacks[text] ||= []) << on_press.to_proc if on_press
      Private.add_button @pointer, text
    end

    def remove_buttons
      self.buttons = {}
    end

    def buttons=(buttons)
      @button_press_callbacks = {}
      it = buttons.each
      block_caller = Fiddle::Closure::BlockCaller.new(Fiddle::TYPE_CONST_STRING, [0]) do
        key, action = it.next
        name = key.to_s
        (@button_press_callbacks[name] ||= []) << action
        name
      rescue StopIteration
        ""
      end
      Private.change_buttons @pointer, buttons.size, block_caller
    end

    class Buttons

      def initialize message_box
        @message_box = message_box
      end

      # def [](selector)
      #   case selector
      #   when Integer
      #     @items[selector]
      #   when :selected
      #     @list_view.selected_item_indices.map{ @items[_1] }
      #   end
      # end

      def alignment=(alignment)
        @message_box.button_alignment = alignment
      end

    end

    def buttons
      Buttons.new self
    end
  end
end