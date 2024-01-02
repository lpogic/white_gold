text_color! 0
text_color_disabled! 111
background_color! 208
background_color_hover! 200
background_color_disabled! 180
selected_text_color! 0
selected_text_color_hover! 0
selected_background_color! 157, 185, 240
selected_background_color_hover! 147, 175, 230
border_color! 200
borders! 1
scrollbar_width! 13
arrow_background_color! 220
arrow_background_color_hover! 220
arrow_background_color_disabled! 240
arrow_color! 80
arrow_color_hover! 40
arrow_color_disabled! 60

button! do
  background_color_down! 180
end

child_window! do
  background_color! 240
  title_bar_color! 220
  distance_to_side! 3
  padding_between_buttons! 3
  show_text_on_title_buttons! true
  title_bar_height! 24
end

editbox! do
  background_color! 220
  background_color_hover! 220
  background_color_disabled! 180
  border_color_focused! 127, 155, 240
  default_text_color! 100
  caret_width! 1
  caret_color! 0
  selected_text_background_color! 157, 185, 240
end

text_area! do
  background_color! 220
  default_text_color! 100
  caret_width! 2
  caret_color! 150, 150, 240
  selected_text_background_color! 157, 185, 240
end

chatbox! do
  background_color! 240
end

combobox! do
  background_color! 220
  default_text_color! 80
  arrow_background_color_hover! 200
end

listbox! do
  background_color! 240
  background_color_hover! 220
end

listview! do
  background_color! 240
  header_background_color! 220
end

menu! do
  selected_background_color! 180
  text_color_disabled! 80
  separator_color! 142
  separator_side_padding! 2
end

progressbar! do
  borders! 1
end

radio_button! do
  borders! 1
  border_color_focused! 127, 155, 240
  background_color_disabled! 180
  text_distance_ratio! 0.3
end

range_slider! do
  track_color! 220
  thumb_color! 200
  thumb_color_hover! 190
  borders! 0
  selected_track_color_hover! 157, 185, 240
end

scrollbar! do
  track_color! 220
  thumb_color! 200
  thumb_color_hover! 190
  arrow_background_color! 200
  arrow_background_color_hover! 190
end

separator! do
  color! 220
end

slider! do
  track_color! 220
  thumb_color! 200
  thumb_color_hover! 190
  borders! 0
  thumb_within_track! true
end

tabs! do
  background_color_hover! 200
  background_color_disabled! 190, 190, 180
  text_color_disabled! 80
  distance_to_side! 8
end
