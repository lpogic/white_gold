require_relative '../lib/white_gold'

# gui.font = "AdobeGothicStd-Bold.otf"
# gui.opacity = 0.5

tab_container! do
  tab! :A do
    btn! do
      p :XD
    end
  end
  tab! :B do
    label! text: "FAFAFA"
  end
  tabs! alignment: :bottom do
    on_tab_select! do
      p _1
    end
  end
end