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

  def init fps: nil, theme: nil, window_size: nil, window_style: nil
    eo = ExternObject.new pointer: nil, autofree: false # object for packing
    if window_size == :fullscreen
      window_style = :fullscreen
      window_size = nil
    end
    window_size ||= [800, 600]
    @window = Window.new *eo.abi_pack(Vector2u, *window_size), *eo.abi_pack(ExternObject::WindowStyle, *(window_style || :default))
    @gui = Gui.new window
    @preserved_pages = {}
    Theme.default = theme if theme
    self.fps = fps if fps
    @frame_delay = 0.015 if !@frame_delay
    @jobs = []
    @initialized = true
  end

  def run page = nil, fps: nil, theme: nil, window_size: nil, window_style: nil
    self.init fps: fps, theme: theme, window_size: window_size, window_style: window_style if !@initialized
    load_page page if page

    next_frame_time = Time.now
    while @gui.self_active?
      @gui.self_poll_events
      now = Time.now
      if @current_page_id != @next_page_id
        if @current_page_id
          page = @preserved_pages[@current_page_id]
          BangNestedCaller.pop
          BangNestedCaller.close_scope page
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
    @next_page_id = @current_page_id = page_id
    case page_id
    when Symbol
      page = @preserved_pages[page_id] = Page.new self
      init_page page
      send(page_id)
    when Class
      page = @preserved_pages[page_id] = page_id.new self
      init_page page
      page.build
    when Proc
      page = @preserved_pages[page_id] = Page.new self
      init_page page
      page.instance_eval &page_id
    end
  end

  def init_page page
    @gui.self_add page, "main_container"
    @current_page = page
    ExternObject.callback_storage = page.widget_callbacks
    ExternObject.global_callback_storage = page.global_callbacks
    ExternObject.data_storage = page.custom_data
    BangNestedCaller.open_scope page
    BangNestedCaller.push page
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
      @counter = 0
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
      self
    end

    def audit
      if @thread
        if @thread.alive?
          return true
        else
          @on_done.(@result) if @on_done
          if @repeat
            @counter += 1
            run
            return true
          else
            return false
          end
        end
      else 
        return !!@job
      end
    end

    def finish result = NO_RESULT
      @repeat = false
      @result = result if result != NO_RESULT
    end

    attr :counter

    def cancel
      @thread.kill
      @thread = @job = nil
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
end
