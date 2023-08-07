require_relative '../lib/white_gold'

module CloseButton
  def close_button **na
    button text: "Zamknij", **na
  end
end

class MyGui < Tgui
  def main_page
    dfl = {
      padding: 3.px
    }
    grid :gr, position: [0.px, 100.px] do |gr|
      button :b, text: "PFF", **dfl, _entered_times: 0

      gr.next_row
      combobox **dfl
      button text: "PFFO", on_press: ->{ go SecondPage }, **dfl
    end

    g[:b].on_mouse_enter do
      b = g[:b]
      b._entered_times += 1
    end

    g[:b].on_press do
      b = g[:b]
      b.text = b._entered_times.to_s
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
