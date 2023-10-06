require_relative 'white_gold/tgui-abi'
require_relative 'white_gold/path/numeric.path'
require_relative 'white_gold/path/object.path'

class Page < Tgui::Group

  WIDGETS_COLLECTION = {
    button: Tgui::Button,
    radio: Tgui::RadioButton,
    checkbox: Tgui::CheckBox,
    editbox: Tgui::EditBox,
    combobox: Tgui::ComboBox,
    color_picker: Tgui::ColorPicker,
    hola: Tgui::HorizontalLayout,
    vela: Tgui::VerticalLayout,
    howr: Tgui::HorizontalWrap,
    group: Tgui::Group,
    radio_group: Tgui::RadioButtonGroup,
    grid: Tgui::Grid,
    list_view: Tgui::ListView,
    picture: false, # dont define defult method
    bitmap_button: Tgui::BitmapButton,
    knob: Tgui::Knob,
    message_box: Tgui::MessageBox,
  }.freeze

  def initialize tgui
    super()
    @tgui = tgui
    @callbacks = {}
    @custom_data = Hash.new do |h, name|
      h[name] = {}
    end
    self.size = [100.pc, 100.pc]
    @top_widget = self
    @names = "@/"
  end

  def inspect
    return "#{object_id}"
  end

  attr :callbacks, :custom_data

  def go page
    @tgui.next_page_id = page
  end

  def +(widget)
    add widget, @names.next!
    self
  end

  def [](name)
    get name.to_s
  end

  def gui
    @tgui.gui
  end

  def window
    @tgui.window
  end

  def g
    self
  end

  def controller type
    type.new self
  end

  def common_widget_post_iniatialize widget, name, **na, &b
    @top_widget.add widget, (name || @names.next!).to_s
      na.each do |k, v|
        if widget.respond_to? "#{k}="
          widget.send("#{k}=", v)
        else
          @top_widget.send(k).send("[]=", widget, v)
        end
      end
      if b
        @top_widget, vice = widget, @top_widget
        b.call widget
        @top_widget = vice
      end
      widget
    end

  WIDGETS_COLLECTION.each do |m, c|
    define_method m do |name = nil, **na, &b|
      common_widget_post_iniatialize c.new, name, **na, &b
    end
  end

  def picture name = nil, **na, &b
    texture = na[:texture] || Texture.produce([
      na[:url],
      na.dig(:part_rect, 0),
      na.dig(:part_rect, 1),
      na.dig(:part_rect, 2),
      na.dig(:part_rect, 3),
      na[:smooth]
    ])
    transparent = na[:transparent] || false
    pic = Tgui::Picture.new texture, transparent
    common_widget_post_iniatialize pic, name, **na.except(:url, :part_rect, :smooth, :transparent), &b
  end

  def respond_to? name
    super || (name.end_with?("!") && (@top_widget.respond_to?(name[...-1]) || respond_to?(name[...-1])))
  end

  def method_missing name, *a, **na, &b
    if name.end_with?("!")
      if @top_widget.respond_to?(name[...-1])
        @top_widget.send(name[...-1], *a, **na, &b)
      else
        send(name[...-1], *a, **na, &b)
      end
    # else super
    end
  end
end

class Tgui

  def [](method_name)
    method(method_name)
  end

  def fps=(fps)
    @frame_delay = 1.0 / fps
  end

  def init init_page = :main_page, fps: nil, theme: nil
    @window = Window.new
    @gui = Gui.new window
    @preserved_pages = {}
    Theme.default = File.expand_path(theme, File.dirname($0)) if theme
    self.fps = fps if fps
    @frame_delay = 0.015 if !@frame_delay
    @next_page_id = init_page
    load_page init_page
  end

  def run init_page = :main_page, fps: nil, theme: nil, init: true
    self.init fps: fps, theme: theme if init

    next_frame_time = Time.now
    while @gui.active?
      @gui.poll_events
      now = Time.now
      if @current_page_id != @next_page_id
        if @current_page_id
          page = @preserved_pages[@current_page_id]
          @gui.remove page
          @preserved_pages.delete(@current_page_id)
        end
        load_page @next_page_id
      end
      sleep next_frame_time - now if next_frame_time > now
      @gui.draw
      next_frame_time += @frame_delay
    end
  end

  def load_page page_id
    @current_page_id = page_id
    case page_id
    when Symbol
      page = @preserved_pages[page_id] = Page.new self
      @gui.add page, "main_container"
      @current_page = page
      ExternObject.callback_storage = page.callbacks
      ExternObject.data_storage = page.custom_data
      send(page_id)
    when Class
      page = @preserved_pages[page_id] = page_id.new self
      @gui.add page, "main_container"
      @current_page = page
      ExternObject.callback_storage = page.callbacks
      ExternObject.data_storage = page.custom_data
      page.build
    when Proc
      page = @preserved_pages[page_id] = Page.new self
      @gui.add page, "main_container"
      @current_page = page
      ExternObject.callback_storage = page.callbacks
      ExternObject.data_storage = page.custom_data
      instance_exec &page_id
    end
  end

  attr_accessor :next_page_id
  attr :gui, :window

  def g
    @current_page
  end

  def go next_page_id
    @next_page_id = next_page_id
  end

  # def main_page
  #   # g.gui.text_size = 7.pc
  #   g += l = Label.new "Witaj w White Gold!"
  #   l.position = [50.pc, 50.pc]
  #   l.vertical_alignment = :center
  #   l.horizontal_alignment = :center
  #   l.auto_size = true
  # end

  Page::WIDGETS_COLLECTION.each do |m, c|
    define_method m do |*a, **na, &b|
      @current_page.send(m, *a, **na, &b)
    end
  end

  def respond_to? name
    super || @current_page.respond_to?(name)
  end

  def method_missing *a, **na, &b
    @current_page.send(*a, **na, &b)
  end
end
