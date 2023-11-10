require_relative 'tgui-abi'
require_relative 'path/numeric.path'
require_relative 'path/object.path'
require_relative 'convention/page'

class WhiteGold
  include Tgui

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
    @jobs = []
    @next_page_id = init_page
    load_page init_page
  end

  def run init_page = :main_page, fps: nil, theme: nil, init: true
    self.init fps: fps, theme: theme if init

    next_frame_time = Time.now
    while @gui.self_active?
      @gui.self_poll_events
      now = Time.now
      if @current_page_id != @next_page_id
        if @current_page_id
          page = @preserved_pages[@current_page_id]
          @gui.self_remove page
          @preserved_pages.delete(@current_page_id)
        end
        load_page @next_page_id
      end
      @jobs.filter!(&:audit)
      sleep next_frame_time - now if next_frame_time > now
      @gui.self_draw
      next_frame_time += @frame_delay
    end
  end

  def load_page page_id
    @current_page_id = page_id
    case page_id
    when Symbol
      page = @preserved_pages[page_id] = Page.new self
      @gui.self_add page, "main_container"
      @current_page = page
      ExternObject.callback_storage = page.callbacks
      ExternObject.data_storage = page.custom_data
      send(page_id)
    when Class
      page = @preserved_pages[page_id] = page_id.new self
      @gui.self_add page, "main_container"
      @current_page = page
      ExternObject.callback_storage = page.callbacks
      ExternObject.data_storage = page.custom_data
      page.build
    when Proc
      page = @preserved_pages[page_id] = Page.new self
      @gui.self_add page, "main_container"
      @current_page = page
      ExternObject.callback_storage = page.callbacks
      ExternObject.data_storage = page.custom_data
      instance_exec &page_id
    end
  end

  attr_accessor :next_page_id
  attr :gui, :window

  def page
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

  class Job
    NO_RESULT = Object.new

    def initialize delay:, repeat:, &b
      @repeat = repeat
      @result = NO_RESULT
      @thread = Thread.new do
        sleep(delay / 1000.0) if delay
        iteration = 1
        case repeat
        when false
          result = b.(iteration, self)
        when true
          while @repeat
            result = b.(iteration, self)
            iteration += 1
          end
        when Integer
          @repeat.times do
            result = b.(iteration, self)
            iteration += 1
          end
        end
        @result = result if @result == NO_RESULT
      end
    end

    def later &b
      if @thread.alive?
        @later = b
      else
        b.(@result)
      end
    end

    def audit
      if @thread.alive?
        return true
      else
        @later.(@result) if @later
        return false
      end
    end

    def finish result = NO_RESULT
      @repeat = false
      @result = result if result != NO_RESULT
    end
  end

  def job delay: nil, repeat: false, &b
    job = Job.new delay:, repeat:, &b
    @jobs << job
    job
  end

  def respond_to? name
    super || @current_page.respond_to?(name)
  end

  def method_missing *a, **na, &b
    @current_page.send(*a, **na, &b)
  end
end
