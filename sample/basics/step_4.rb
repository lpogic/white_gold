require 'white_gold'

button! position: :center, size: [300, 150] do
  text_size! 30
  text! "Exit"
  on_press! do
    window.close!
  end
end