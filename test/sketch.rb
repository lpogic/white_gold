require_relative '../lib/white_gold'

module CloseButton
  def close_button **na
    button text: "Zamknij", **na
  end
end

class MyGui < Tgui
  def main_page
    group width: 100.pc, height: 100.pc do
      button :btn, text: "Color", position: [80.px, 0.px]
      button text: "Dalej", on_press: ->{ go SecondPage }
      checkbox text: "CZEKBOKS", position: [150.px, 0.px]
    end

    g[:btn].on_press do
      color_picker on_ok_press: ->{ p "XD" }
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

MyGui.new.run theme: 'resource/Black.txt'
# MyGui.new.run SecondPage
