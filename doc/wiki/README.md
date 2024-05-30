Welcome to the _white_gold_ documentation home page!
===

Basics
---

### 0. No title
Simplest application written in white_gold:
```RUBY
require 'white_gold'
```
When library is loaded this way, window is shown on script end.

### 1. Hello world
Let's customize window title:
```RUBY
require 'white_gold'

title! "Hello world application"
```
Methods with trailing '!' are quiet common in white_gold. Generally, they are used to change the state of the currently running object.

### 2. Button
Widgets are also created by methods with bang:
```RUBY
require 'white_gold'

button! text: "New Button", position: :center
```
Several named arguments can be passed with the widget creating method call. They will be used as the new widget attributes.

### 3. Widget tree
To build widget tree, call widget creating methods inside associated block:
```RUBY
require 'white_gold'

child_window! resizable: true do
  editbox! position: [1/3r, :center]
  button! text: "Button", position: [2/3r, :center]
end
```
Providing an array as position attribute allows to set x and y coordinates individually. 
When rational is used as position argument, then it is interpreted as relative to the parent size.

### 4. Callbacks
In associated blocks attributes can be adapted, too:
```RUBY
require 'white_gold'

button! position: :center, size: [300, 150] do
  text_size! 30
  text! "Exit"
  on_press! do
    window.close!
  end
end
```
`on_press!` can be called multiple times, every time new signal listener is attached. The block given as the argument is evaluated when the button is pressed.

### 5. Themes
Theme defines how widgets looks like. `theme!` method allows to set up global theme for all widgets, or custom one for particular object:
```RUBY
require 'white_gold'

theme! :light do
  button! do
    rounded_border_radius! 10
  end
end

button! text: "Normal", position: [1/4r, 1/4r], size: [200, 100], text_size: 30

button! text: "Green", position: [3/4r, 1/4r], size: [200, 100], text_size: 30 do
  theme! do
    background_color! :green
    background_color_hover! Color.from(:green).lighter(20)
    background_color_down! Color.from(:green).darker(20)
  end
end

# blue_button custom theme class example:

theme! do
  button! :blue_button do
    background_color! :blue
    background_color_hover! Color.from(:blue).lighter(20)
    background_color_down! Color.from(:blue).darker(20)
  end
end

button! text: "Blue", position: [1/4r, 3/4r], size: [200, 100], text_size: 30, theme: :blue_button

button! text: "Odd", position: [3/4r, 3/4r], size: [200, 100], text_size: 30 do
  theme! :blue_button do
    borders! 5
    border_color! :red
  end
end
```

### 6. Custom widgets
List of base widgets with methods to create them can be found [here](./api). 
Custom widgets can be created by customizing and combining base widgets:
```RUBY
require 'white_gold'

def! :hello_world do
  messagebox! text: "Hello world" do |box|
    button! "Close" do
      on_press! do
        box.close
      end
    end
  end
end

hello_world!

# If widget should be available in every Container, define it inside the Container class

Container.def! :editbox_with_confirm do |confirm_text: "Save", **na, &b|
  grid! **na do
    editbox!
    button! text: confirm_text
    b&.call
  end
end

# Root container is also Container

editbox_with_confirm! position: :center

child_window! do
  editbox_with_confirm! position: :center, confirm_text: "Send"
end
```
Notice, that bang methods are not defined in common way (`def! :hello_world` instead of `def hello_world!`).

DSL
---

### Building gui structure:<br>

see [extree](https://github.com/lpogic/extree) gem

### Widgets attributing:<br>

Almost every widget is created empty. Attribute setting is invoked on existing instance:

```RUBY
require 'white_gold'

button = button!
button.text = "Button"
button.position = [50, 50]
button.on_press = proc do
  puts "Have I been pressed?"
end
```

There are two other ways for setting attributes. First one uses extree methods:

```RUBY
require 'white_gold'

button! do
  text! "Button"
  position! 50, 50 # implicit multiple arguments to array conversion
  on_press! do # implicit block to proc conversion
    puts "Have I been pressed?"
  end
end
```

Second one is passing attributes as named arguments:

```RUBY
require 'white_gold'

button! text: "Button", position: [50, 50], on_press: proc{ puts "Have I been pressed?" }
```

All of 3 methods can be mixed of course:

```RUBY
require 'white_gold'

button = button! text: "Button" do
  on_press! do
    puts "Have I been pressed?"
  end
end
button.position = [50, 50]

```

### Method to proc conversion:<br>

see [procify](https://github.com/lpogic/procify) gem

API
---

Methods prefixed with `api_`, `abi_`, `self_`, `_abi_` belongs to the internal API and shouldn't be used directly.<br>
Generated API reference: [Widgets API](./api)
