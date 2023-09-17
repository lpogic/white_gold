require_relative '../lib/white_gold'

module CloseButton
  def close_button **na
    button text: "Zamknij", **na
  end
end

class MyGui < Tgui
  def main_page
    lw = list_view size: [100.pc, 80.pc], resizable_columns: true, multi_select: true, item_height: 30, header_text_size: 20,
      separator_width: 10, header_separator_height: 10, grid_lines_width: 2, auto_scroll: false, show_vertical_grid_lines: false,
      show_horizontal_grid_lines: true, expand_last_column: true do |l|
      column text: "A", width: 100
      column text: "B", width: 100
      column text: "C", width: 100
      column text: "D", width: 100
      column text: "E", width: 100
      (1..10).each do |i|
        item data: ["A#{i}", "B#{i}", "C#{i}", "D#{i}"]
      end
    end

    button position: [12.px, 90.pc], text: "Add item", on_press: ->{ lw.item data: ["XD"] }
    button position: [100.px, 90.pc], text: "Add column", on_press: ->{ lw.items[:selected].each{ p _1.data } }
    button position: [200.px, 90.pc], text: "DO IT", on_press: ->{ lw.items[1].selected = true }
    # button position: [300.px, 90.pc], text: "DO IT", on_press: ->{ p lw.items[:selected] }
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
