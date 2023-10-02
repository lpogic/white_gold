require_relative '../lib/white_gold'

module CloseButton
  def close_button **na
    button text: "Zamknij", **na
  end
end

class MyGui < Tgui
  include CloseButton

  def main_page
    close_button on_press: proc{ message_box text: "Message Box oks oksok s", button_alignment: :center do |mb|
        mb.buttons = {
          OK: proc{ p "OK"; mb.close },
          Zamknij: proc{ mb.close },
        }
      end
    }
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
