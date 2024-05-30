require 'white_gold'

button = button! text: "Button" do
  on_press! do
    puts "Have I been pressed?"
  end
end
button.position = [50, 50]
