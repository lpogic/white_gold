require_relative '../lib/white_gold'

# gui.font = "AdobeGothicStd-Bold.otf"
# gui.opacity = 0.5

slider! max: 100 do
  on_value_change! do
    p _1
  end
end