require 'white_gold'

button = button!
button.send! text: "Button", position: [50, 50] do
  on_press! do
    puts "Have I been pressed?"
  end
end