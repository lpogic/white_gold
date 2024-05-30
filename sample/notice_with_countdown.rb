$window_style = [:none, :topmost]
# require 'white_gold'
require_relative "../lib/white_gold"

window.position! *gui.screen_size.then{ [_1[0] - 346, _1[1] - 250] }
window.size! 344, 208
theme! :light do
  panel! do
    background_color! :white
  end
end

@option = :noaction

text_size! 16

label! text: "Autodestrukcja", position: [:center, 10], alignment: :center, text_size: 20
@l = label! position: :center, text_size: 14, alignment: :center
grid! position: :end, padding: [3, 6, 6, 6] do
  button! text: "Wyłącz", on_press: proc{ @option = :cancel; window.close }
  button! text: "Odłóż", on_press: proc{ @option = :skip; window.close }
  button! text: "Dostosuj", on_press: proc{ @option = :adjust; window.close }
end

def countdown_label
  "zostanie uruchomiona za\n#{@seconds}\nsekund"
end

def countdown_job
  @seconds = 5
  job repeat: true do |j|
    j << 1
    sleep 1
    @seconds -= 1
  end.tip do
    if @seconds > 0
      @l.text = countdown_label
    else
      window.close
    end
  end
end

@cd_job = countdown_job
on_mouse_enter! do
  @cd_job.cancel
  @l.text! "Wybierz co chcesz zrobić:"
end

on_mouse_leave! do
  @cd_job = countdown_job
end

run!

puts @option