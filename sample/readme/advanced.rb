require 'white_gold/master'

class FirstPage < Page
  def build
    button! text: "Second Page", position: :center, on_press: proc{ go SecondPage }
  end

end

class SecondPage < Page
  def build
    button! text: "Exit", position: :center, on_press: proc.exit
  end

  def exit
    window.close
  end
end

WhiteGold.new.run FirstPage