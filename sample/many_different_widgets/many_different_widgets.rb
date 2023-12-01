require_relative '../../lib/white_gold'

Theme.default = "Black.txt"
picture! url: "RedBackground.jpg"
Unit.default = :px

tabs! tab_height: 30, position: [70, 40] do
  tab! "Tab - 1"
  tab! "Tab - 2"
  tab! "Tab - 3"
end

menu! height: 22 do
  item! "File" do
    item! "Load"
    item! "Save"
    item! "Exit"
  end
  item! "Edit" do
    item! "Copy"
    item! "Paste"
  end
  item! "Help" do
    item! "About"
  end
end

label! text: "This is a label.\nAnd these are radio buttons:", position: [10, 90], text_size: 18

radio_button! position: [20, 140], text: "Yep!", size: [25, 25]
radio_button! position: [20, 170], text: "Nope!", size: [25, 25]
radio_button! position: [20, 200], text: "Don't know!", size: [25, 25]

label! text: "We've got some edit boxes:", position: [10, 240], text_size: 18

editbox! size: [200, 25], text_size: 18, position: [10, 270], default_text: "Click to edit text..."

label! text: "And some list boxes too...", position: [10, 310], text_size: 18

listbox! size: [250, 120], item_height: 24, position: [10, 340] do
  item! "Item 1"
  item! "Item 2"
  item! "Item 3"
end

label! text: "It's the progress bar below", position: [10, 470], text_size: 18

@progress_bar = progress_bar! position: [10, 500], size: [200, 20], value: 50

label! text: "#{@progress_bar.value}%", position: [220, 500], text_size: 18

label! text: "That's the slider", position: [10, 530], text_size: 18

slider! position: [10, 560], size: [200, 18], value: 4

scrollbar! do
  position! 380, 40
  size! 18, 540
  max! 100
  viewport_size! 70
end

combobox! size: [120, 21], position: [420, 40] do
  item! "Item 1"
  item! "Item 2", selected: true
  item! "Item 3"
end

child_window! client_size: [250, 120], position: [420, 80], title: "Child window" do |child|
  label! text: "Hi! I'm a child window.", position: [30, 30], text_size: 15
  button! position: [75, 70], text: "OK", size: [100, 30] do
    on_press! do
      child.close
    end
  end
end

checkbox! position: [420, 240], text: "Ok, I got it", size: [25, 25]
checkbox! position: [570, 240], text: "No, I didn't", size: [25, 25]

label! text: "Chatbox", position: [420, 280], text_size: 18

chat_box! size: [300, 100], text_size: 18, position: [420, 310], lines_start_from_top: true do
  line! "texus: Hey, this is TGUI!", color: :green
  line! "Me: Looks awesome! ;)", color: :yellow
  line! "texus: Thanks! :)", color: :green
  line! "Me: The widgets rock ^^", color: :yellow
end

btn! "Exit", position: [(gui.view[2] - 115), (gui.view[3] - 50)], size: [100, 40] do
  window.close
end