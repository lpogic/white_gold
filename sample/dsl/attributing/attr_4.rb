require 'white_gold'

button = button!
upon! button, text: "Button", position: [50, 50] do # note: 'upon!' puts first argument on top of the bang stack
  on_press! do
    puts "Have I been pressed?"
  end
end