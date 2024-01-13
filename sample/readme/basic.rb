require 'white_gold'

button! text: "Exit", position: :center, on_press: proc.exit

def exit
  window.close
end