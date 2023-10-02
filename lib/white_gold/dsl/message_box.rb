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

    def buttons=(buttons)
      buttons.each do |key, action|
        name = key.to_s
        Private.add_button @pointer, name
        (@button_press_callbacks[name] ||= []) << action
      end
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