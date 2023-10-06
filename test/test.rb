require_relative '../lib/wg'

def main_page
  message_box! text: "Message Box", position: [41.pc, 43.pc] do
    button! text: "Close", on_press: proc{ window.close }
    button! text: "Page 2", on_press: proc{ go :second_page }
  end
end

def second_page
  button! text: "Page 1", on_press: proc{ go :main_page }
end