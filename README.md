White Gold 
===

Ruby gem for building pure ruby graphical user interface.<br>
Uses [TGUI](https://tgui.eu/) & [SFML](https://www.sfml-dev.org/) as backend.

Taste
---

```RUBY
require 'white_gold'

window.title = "Greeting app"
gui.text_size = 30

label! text: "Enter your name:", position: [100, 150], size: [340, 44]
editbox! :name, position: [375, 146], size: [280, 44]
button! text: "Then press the button", position: [200, 250] do
  on_press! do
    text = page[:name].text
    text = "world" if text.strip.empty?
    message_box! text: "Hello #{text}!", position: :center do
      button! text: "Close", on_press: proc{ window.close }
    end
  end
end
```
### Output:<br>
<img src="./.github/img/screen_1.PNG" width="30%">
<img src="./.github/img/screen_2.PNG" width="30%">



Check out [sample](https://github.com/lpogic/white_gold/tree/master/sample) for more.

Requirements
---
- Ruby >= 3.2.2
- Fiddle >= 1.1.1

Installation
---
1) From source
```
git clone https://github.com/lpogic/white_gold
gem build ./white_gold/white_gold.gemspec
gem install white_gold-0.0.1.gem
```
2) From official
```
Will be possible one day
```

Basic usage
---
```RUBY
require 'white_gold'

button! text: "Exit", position: :center, on_press: proc.exit

def exit
  window.close
end
```

Advanced usage
---
```RUBY
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
```

Status
---
A hobby project developed by one person.

Contact
---
name: Łukasz Pomietło<br>
email: oficjalnyadreslukasza@gmail.com