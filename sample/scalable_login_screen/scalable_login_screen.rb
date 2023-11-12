require_relative '../../lib/white_gold'

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

picture! url: "xubuntu_bg_aluminium.jpg", size: [100, 100]

editbox! :username, size: [66.67, 12.5], position: [16.67, 16.67], default_text: "Username"
editbox! :password, size: [66.67, 12.5], position: [16.67, 41.6], password_character: "*", default_text: "Password"
button! text: "Login", size: [50, 16.67], position: [25, 70], on_press: proc{ login page[:username], page[:password] }
