require 'extree'
require 'procify'
require_relative 'convention/boolean'
require_relative 'path/kernel.path'
require_relative 'path/numeric.path'
require_relative 'path/object.path'
require_relative 'path/string.path'
require_relative 'tgui-abi'
require_relative 'convention/page'

class WhiteGold
  include Tgui

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
    @window = Window.new *eo.abi_pack(Vector2i, *window_size), *eo.abi_pack(ExternObject::WindowStyle, *(window_style || :default))
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
          Extree::Seed.pop
          Extree::Seed.close_scope page
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
    @gui.page = page
    @current_page = page
    ExternObject.callback_storage = page.widget_callbacks
    ExternObject.global_callback_storage = page.global_callbacks
    ExternObject.data_storage = page.custom_data
    Extree::Seed.open_scope page
    Extree::Seed.push page
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

    def initialize repeat:, run: true, &b
      @queue = Thread::Queue.new
      @mutex = Thread::Mutex.new
      @repeat = repeat
      @job = b
      self.run if run
    end

    def run
      if !@thread || !@thread.alive?
        @thread = Thread.new do
          loop do
            last_spin = false
            @mutex.synchronize do
              last_spin = !@repeat
            end
            @job.call self
            break if last_spin
          end
        end
      end
    end

    def tip &b
      @tip = b
      b.(self) if @thread && !@thread.alive?
      self
    end

    def audit
      @tip&.call @queue.pop, self if !@queue.empty?
      @thread ? @thread.alive? : !!@job
    end

    attr_accessor :queue
    attr :repeat

    def <<(value)
      @queue << value
      self
    end

    def repeat=(repeat)
      @mutex.synchronize do
        @repeat = repeat
      end
    end

    def cancel
      @thread&.kill
      @thread = @job = nil
    end
  end

  def job repeat: false, run: true, &b
    job = Job.new repeat:, run:, &b
    @jobs << job
    job
  end

  def after delay = nil, run: true, &b
    if delay
      job run: do |j|
        sleep(delay / 1000.0)
        j.queue << nil
      end.tip &b
    else
      job(run: false).tip(&b).tap{ _1.queue << nil }
    end
  end

  def timer target_pulse_time, run: true, &b
    nms = nil
    target_pulse_time /= 1000.0 # ms => s
    job repeat: true, run: do |j|
      ms = Time.now
      nms = (nms || ms) + target_pulse_time
      j.queue << ms if j.queue.empty?
      sleep(nms - ms) if nms > ms
    end.tip &b
  end
end
