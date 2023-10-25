require_relative '../lib/white_gold'

# Config.default_unit = :pc
# Club.global {
#   Widget => {
#     image_scaling: 1
#   }
# }
club! Widget, {
  position: :begin
}

club! ComboBox, {
  position: :center
}
club! ToolTip, {
  size: [80.px, 400.px],
}
club! EditBox, {
  mouse_cursor: :text
}

ToolTip.set_distance_to_mouse 1, 1


# button! :but, text: "Button", position: :center do
#   on_click! do |*pos|
#     p pos
#   end
# end

editbox! :in, position: [30.pc, :center], limited_text_width: true do
  on_caret_position_change! do
    p _1
  end
  tooltip! do
    panel! size: 70.px do
      picture! url: "app.jpg"
      label! text: "XD"
    end
  end
end
editbox! :out, position: [62.pc, :center]

combobox! mouse_cursor: :hand do
  item! :square
  item! :cube
  item! :root
  on_item_select! do |item|
    input = page[:in].text.to_i
    page[:out].text = case item
    when :square then input * input
    when :cube then input * input * input
    when :root then Integer.sqrt(input)
    else ""
    end
  end
end

button! text: "BUT" do
  on_press! do
    page[:in].resize 10, 10
  end
end

button! text: "BUT1", position: [15, 2] do
  on_press! do
    page[:in].finish_animations
  end
end