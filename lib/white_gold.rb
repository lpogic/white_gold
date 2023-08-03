require_relative 'white_gold/tgui-abi'

class Page

  SUPPORTED_WIDGETS = {
    button: Tgui::Button,
    checkbox: Tgui::CheckBox,
    color_picker: Tgui::ColorPicker,
    group: Tgui::Group,
  }.freeze

  def initialize tgui
    @tgui = tgui
    @callbacks = {}
    @main_container = Tgui::Group.new
    @main_container.size = [100.pc, 100.pc]
    @top_container = @main_container
    @names = "@/"
  end

  def inspect
    return "#{object_id}"
  end

  attr :main_container, :callbacks

  def go page
    @tgui.next_page_id = page
  end

  def +(widget)
    @main_container.add widget, @names.next!
    self
  end

  def [](name)
    @main_container.get name.to_s
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

  SUPPORTED_WIDGETS.each do |m, c|
    if c < Tgui::Container
      define_method m do |name = nil, **na, &b|
        w = c.new
        na.each do |k, v|
          w.send("#{k}=", v)
        end
        @top_container.add w, (name || @names.next!).to_s
        if b
          @top_container, vice = w, @top_container
          b.call w
          @top_container = vice
        end
        w
      end
    else
      define_method m do |name = nil, **na, &b|
        w = c.new
        na.each do |k, v|
          w.send("#{k}=", v)
        end
        @top_container.add w, (name || @names.next!).to_s
        if b
          b.call w
        end
        w
      end
    end
  end
end

class Tgui

  def fps=(fps)
    @frame_delay = 1.0 / fps
  end

  def run init_page = :main_page, fps: nil, theme: nil
    @window = Window.new
    @gui = Gui.new window
    @preserved_pages = {}
    Theme.default = File.expand_path(theme, File.dirname($0)) if theme

    @next_page_id = init_page
    load_page @next_page_id

    self.fps = fps if fps
    @frame_delay = 0.015 if !@frame_delay

    next_frame_time = Time.now
    while @gui.active?
      @gui.poll_events
      now = Time.now
      if @current_page_id != @next_page_id
        page = @preserved_pages[@current_page_id]
        @gui.remove page.main_container
        @preserved_pages.delete(@current_page_id)
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
      @gui.add page.main_container, "main_container"
      @current_page = page
      ExternObject.callback_storage = page.callbacks
      send(page_id)
    when Class
      page = @preserved_pages[page_id] = page_id.new self
      @gui.add page.main_container, "main_container"
      @current_page = page
      ExternObject.callback_storage = page.callbacks
      page.build
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

  def main_page
    # g.gui.text_size = 7.pc
    g += l = Label.new "Witaj w White Gold!"
    l.position = [50.pc, 50.pc]
    l.vertical_alignment = :center
    l.horizontal_alignment = :center
    l.auto_size = true
  end

  Page::SUPPORTED_WIDGETS.each do |m, c|
    define_method m do |*a, **na, &b|
      @current_page.send(m, *a, **na, &b)
    end
  end
end
