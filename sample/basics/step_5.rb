require 'white_gold'

theme! :light do
  button! do
    rounded_border_radius! 10
  end
end

button! text: "Normal", position: [1/4r, 1/4r], size: [200, 100], text_size: 30

button! text: "Green", position: [3/4r, 1/4r], size: [200, 100], text_size: 30 do
  renderer! do
    background_color! :green
    background_color_hover! Color.from(:green).lighter(20)
    background_color_down! Color.from(:green).darker(20)
  end
end

# renderer also can be defined in theme and used later

theme! do
  button! :blue do
    background_color! :blue
    background_color_hover! Color.from(:blue).lighter(20)
    background_color_down! Color.from(:blue).darker(20)
  end
end

button! text: "Blue", position: [1/4r, 3/4r], size: [200, 100], text_size: 30, renderer: :blue

button! text: "Odd", position: [3/4r, 3/4r], size: [200, 100], text_size: 30 do
  renderer! :blue do
    borders! 5
    border_color! :red
  end
end