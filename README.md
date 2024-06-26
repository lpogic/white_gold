white_gold - TGUI based Ruby gem for quick native application developing
===

Ruby gem for building pure ruby graphical user interface.<br>
Uses [TGUI](https://tgui.eu/) & [SFML](https://www.sfml-dev.org/) as a backend.<br>
Dedicated to creating simple applications and learning programming.

### 1. Taste
```RUBY
require 'white_gold'

title! "Greeting app"
text_size! 30

label! text: "Enter your name:", position: [100, 150], size: [340, 44]
@name = editbox! position: [375, 146], size: [280, 44]
button! text: "Then press the button", position: [200, 250] do
  on_press! do
    text = @name.text
    text = "world" if text.strip.empty?
    gui.messagebox! text: "Hello #{text}!", position: :center do
      button! text: "Close", on_press: proc{ window.close }
    end
  end
end
```

### Output:<br>
<img src="./.github/img/screen_1.PNG" width="30%">   <img src="./.github/img/screen_2.PNG" width="30%">



Check out [sample](https://github.com/lpogic/white_gold/tree/master/sample) for more.

Requirements
---
- Ruby >= 3.2.2
- Fiddle >= 1.1.1

Binaries for Windows and Linux are bundled with the gem.

Installation
---
1) From official
```
gem install white_gold
```
2) From source
```
git clone https://github.com/lpogic/white_gold
cd white_gold
gem build white_gold.gemspec
gem install white_gold-0.1.0.gem
```

### 2. Basic usage
```RUBY
require 'white_gold'

button! text: "Exit", position: :center, on_press: proc.exit

def exit
  window.close
end
```

### 3. Advanced usage
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


Check out [documentation](https://github.com/lpogic/white_gold/tree/master/doc/wiki) for more info.

Status
---
A hobby project.

Authors
---
- Łukasz Pomietło (oficjalnyadreslukasza@gmail.com)
