require_relative 'convention/boolean'
require_relative 'path/kernel.path'
require_relative 'path/numeric.path'
require_relative 'path/object.path'
require_relative 'path/string.path'
require_relative 'tgui-abi'
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
    Theme.default = theme if theme
    self.fps = fps if fps
    @frame_delay = 0.015 if !@frame_delay
    @jobs = []
    @next_page_id = init_page
    load_page init_page
  end

  def run init_page = :main_page, fps: nil, theme: nil, init: true
    self.init init_page, fps: fps, theme: theme if init

    next_frame_time = Time.now
    while @gui.self_active?
      @gui.self_poll_events
      now = Time.now
      if @current_page_id != @next_page_id
        if @current_page_id
          page = @preserved_pages[@current_page_id]
          @gui.self_remove page
          page.disconnect
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
      ExternObject.callback_storage = page.widget_callbacks
      ExternObject.global_callback_storage = page.global_callbacks
      ExternObject.data_storage = page.custom_data
      send(page_id)
    when Class
      page = @preserved_pages[page_id] = page_id.new self
      @gui.self_add page, "main_container"
      @current_page = page
      ExternObject.callback_storage = page.widget_callbacks
      ExternObject.global_callback_storage = page.global_callbacks
      ExternObject.data_storage = page.custom_data
      page.build
    when Proc
      page = @preserved_pages[page_id] = Page.new self
      @gui.self_add page, "main_container"
      @current_page = page
      ExternObject.callback_storage = page.widget_callbacks
      ExternObject.global_callback_storage = page.global_callbacks
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

  class Job
    NO_RESULT = Object.new

    def initialize delay:, repeat:, run: true, &b
      @delay = delay
      @repeat = repeat
      @job = b
      @result = NO_RESULT
      self.run if run
    end

    def run
      @thread = Thread.new do
        sleep(@delay / 1000.0) if @delay
        @result = @job.(self)
      end
    end

    def on_done &b
      @on_done = b
      b.(@result) if @thread && !@thread.alive?
    end

    def audit
      if @thread
        if @thread.alive?
          return true
        else
          @on_done.(@result) if @on_done
          if @repeat
            run
            return true
          else
            return false
          end
        end
      else 
        return true
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

  def timer delay_ = nil, delay: nil, repeat: false, &b
    job delay: delay || delay_, repeat: do
    end.on_done &b
  end

  def respond_to? name
    super || @current_page.respond_to?(name)
  end

  def method_missing name, *a, **na, &b
    if @current_page.respond_to? name
      @current_page.send(name, *a, **na, &b)
    elsif @gui.respond_to? name
      @gui.send(name, *a, **na, &b)
    elsif @window.respond_to? name
      @window.send(name, *a, **na, &b)
    else
      no_method_error = "method '#{name}' missing in Page/Gui/Window"
      raise no_method_error
    end
  end
end
