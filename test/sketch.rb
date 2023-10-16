require_relative '../lib/wg'

def login username, password
  puts "Username: " + username.text
  puts "Password: " + password.text
end

def update_text_size gui
  window_height = gui.view[3]
  gui.text_size = (0.07 * window_height).round
end

update_text_size gui
gui.on_view_change{ update_text_size gui }

picture! url: "xubuntu_bg_aluminium.jpg", size: [100.pc, 100.pc]

@edit_box_username = editbox! size: [66.67.pc, 12.5.pc], 
  position: [16.67.pc, 16.67.pc], default_text: "Username"

@edit_box_password = editbox! size: [66.67.pc, 12.5.pc],
  position: [16.67.pc, 41.6.pc], password_character: "*",
  default_text: "Password"

@button = button! text: "Login", size: [50.pc, 16.67.pc],
  position: [25.pc, 70.pc], on_press: proc{ login @edit_box_username, @edit_box_password }

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
