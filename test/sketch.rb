require_relative '../lib/white_gold'

# gui.font = "AdobeGothicStd-Bold.otf"
# gui.opacity = 0.5

ToolTip.set_initial_delay 1000

text_area! do
  text! "LALLWLELAWE\noawejawe"

  on_caret_change! do
    p _1.caret_position
  end

  tooltip! do
    label! text: "TOOTL"
  end
end

btn! do
  window.close
end