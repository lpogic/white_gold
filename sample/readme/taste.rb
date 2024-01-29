require 'white_gold'

title! "Greeting app"
text_size! 30

label! text: "Enter your name:", position: [100, 150], size: [340, 44]
@name = editbox! position: [375, 146], size: [280, 44]
button! text: "Then press the button", position: [200, 250] do
  on_press! do
    text = @name.text
    text = "world" if text.strip.empty?
    gui.messagebox! text: "Hello #{text}!", position: :center do
      button! text: "Close", on_press: proc{ window.close }
    end
  end
end