# require_relative '../lib/white_gold'

# module CloseButton
#   def close_button! **na
#     button! text: "Zamknij", **na
#   end
# end

# class Controller
#   def initialize page
#     @page = page
#   end

#   def [](method_name)
#     method(method_name)
#   end

#   def respond_to? name
#     super || @page.respond_to?(name)
#   end

#   def method_missing name, *a, **na, &b
#     if @page.respond_to?(name)
#       @page.send(name, *a, **na, &b)
#     else
#       super
#     end
#   end
# end

# class MyGui < Tgui
#   include CloseButton

#   def main_page
#     m = menu! do
#       item! text: "XD", on_press: proc{ p "XD" }
#       item! text: "XDL" do
#         item! text: "DALD" do
#           item! text: "DA"
#         end
#       end
#       item! text: "DALD" do
#         item! text: "DA"
#       end
#     end
#     m.xd
#   end

#   def go_second
#     go SecondPage
#   end
# end

# class Messager < Controller

#   def show
#     @msg ||= begin
#       message_box! text: "Message Box oks oksok s", button_alignment: :center do
#         button! text: "Zamknij", on_press: self[:close]
#         button! text: "Dodaj", on_press: proc{ message_box! text: "XD" }
#       end
#     end
#   end

#   def add_button
#     @msg&.button text: "Dodaj", on_press: proc{ @msg.text = "OO" }
#   end

#   def close
#     @msg&.close
#     @msg = nil
#   end
# end


# class SecondPage < Page
#   include CloseButton
#   @@counter = 0

#   def build
#     @@counter += 1

#     button! text: "Wstecz #{@@counter}", on_press: ->{ go :main_page }
#     close_button! position: [80.px, 0.px], on_press: msg_box
#   end

#   def msg_box
#     proc do
#       message_box text: "Message Box oks oksok s", button_alignment: :center do |mb|
#         button text: "OK", on_press: proc{ p "OK" }
#       end
#     end
#   end
# end

# MyGui.new.run# theme: 'resource/Black.txt'
# # MyGui.new.run SecondPage

class Foo
  def self.bar
    p :bar
  end
end

class Bar < Foo
end

Foo.define_singleton_method :foo do
  send(:bar)
end

Bar.foo