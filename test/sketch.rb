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



# button! :but, text: "Button", position: :center do
#   on_click! do |*pos|
#     p pos
#   end
# end

editbox! :in, position: [20.pc, :center]
editbox! :out, position: [62.pc, :center]

combobox! do
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