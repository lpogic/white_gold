require_relative '../lib/white_gold'

module CloseButton
  def close_button **na
    button text: "Zamknij", **na
  end
end

class MyGui < Tgui
  def main_page
    group :gr, width: 100.pc, height: 100.pc do
      button :btn, text: "Color", position: [80.px, 0.px]
      button text: "Dalej", on_press: ->{ go SecondPage }
      checkbox text: "CZEKBOKS", position: [150.px, 0.px], on_change: proc{ p _1 }
      editbox position: [250.px, 0.px], on_text_change: proc{ go SecondPage }, on_mouse_press: proc{ p _1.x, _1.y }
    end

    g[:btn].on_press do
      p g[:gr].get_widgets
      color_picker on_color_change: proc{ p _1 }
    end
  end
end

class SecondPage < Page
  include CloseButton
  @@counter = 0

  def build
    @@counter += 1

    button text: "Wstecz #{@@counter}", on_press: ->{ go :main_page }
    close_button position: [80.px, 0.px], on_press: ->{ window.close }
  end
end

MyGui.new.run# theme: 'resource/Black.txt'
# MyGui.new.run SecondPage
