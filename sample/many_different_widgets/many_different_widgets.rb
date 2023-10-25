require_relative '../../lib/white_gold'

# picture! url: "RedBackground.jpg"

tabs! tab_height: 30, position: [70, 40] do
  tab! text: "Tab - 1"
  tab! text: "Tab - 2"
  tab! text: "Tab - 3"
end

menu! height: 22 do
  item! text: "File" do
    item! text: "Load"
    item! text: "Save"
    item! text: "Exit"
  end
  item! text: "Edit" do
    item! text: "Copy"
    item! text: "Paste"
  end
  item! text: "Help" do
    item! text: "About"
  end
end

label! text: "This is a label.\nAnd these are radio buttons:",
  position: [10, 90], text_size: 18

radio_button! position: [20, 140], text: "Yep!", size: [25, 25]
radio_button! position: [20, 170], text: "Nope!", size: [25, 25]
radio_button! position: [20, 200], text: "Don't know!", size: [25, 25]

label! text: "We've got some edit boxes:", position: [10, 240], text_size: 18

editbox! size: [200, 25], text_size: 18, position: [10, 270],
  default_text: "Click to edit text..."

label! text: "And some list boxes too...", position: [10, 310], text_size: 18

listbox! size: [250, 120], item_height: 24, position: [10, 340] do
  item! text: "Item 1"
  item! text: "Item 2"
  item! text: "Item 3"
end

label! text: "It's the progress bar below", position: [10, 470], text_size: 18

@progress_bar = progress_bar! position: [10, 500], size: [200, 20], value: 50

label! text: "#{@progress_bar.value}%", position: [220, 500], text_size: 18

label! text: "That's the slider", position: [10, 530], text_size: 18

slider! position: [10, 560], size: [200, 18], value: 4

scrollbar! position: [380, 40], size: [18, 540], maximum: 100, viewport_size: 70

scrollbar! do
  position! 380, 40
  size! 18, 540
  maximum! 100
  viewport_size! 70
end

combobox! size: [120, 21], position: [420, 140] do
  item! text: "Item 1"
  item! text: "Item 2", selected: true
  item! text: "Item 3"
end

child_window! client_size: [250, 120], position: [420, 80], title: "Child window" do |child|
  label! text: "Hi! I'm a child window.", position: [30, 30], text_size: 15
  button! position: [75, 70], text: "OK", size: [100, 30],
    on_press: proc{ child.visible = false }
end

checkbox! position: [420, 240], text: "Ok, I got it", size: [25, 25]
checkbox! position: [570, 240], text: "No, I didn't", size: [25, 25]

label! text: "Chatbox", position: [420, 280], text_size: 18

button! position: [(gui.view[2] - 115), (gui.view[3] - 50)], text: "Exit", size: [100, 40]