require_relative "club"

class Page < Tgui::Group

  def initialize tgui
    super()
    @tgui = tgui
    @widget_callbacks = {}
    @global_callbacks = {}
    @custom_data = Hash.new do |h, name|
      h[name] = {}
    end
    @clubs = {}
    @custom_renderers = {}
    self.size = [100.pc, 100.pc]
  end

  def inspect
    return "#{object_id}"
  end
  
  def build
  end

  def respond_to? name
    super || 
    (name.end_with?("!") && bang_respond_to?(name[...-1])) ||
    @tgui.gui.respond_to?(name) ||
    @tgui.window.respond_to?(name)
  end

  def method_missing name, *a, **na, &b
    if name.end_with? "!"
      bang_method_missing name, *a, **na, &b
    elsif @tgui.gui.respond_to? name
      @tgui.gui.send name, *a, **na, &b
    elsif @tgui.window.respond_to? name
      @tgui.window.send name, *a, **na, &b
    else super
    end
  end

  def disconnect
    @global_callbacks.each do |id, signal|
      signal.disconnect id
    end
  end

  attr :widget_callbacks, :global_callbacks, :custom_data, :clubs, :custom_renderers

  def go page
    @tgui.next_page_id = page
  end

  def job **na, &b
    @tgui.job **na, &b
  end

  def timer *a, **na, &b
    @tgui.timer *a, **na, &b
  end

  def gui
    @tgui.gui
  end

  def window
    @tgui.window
  end

  def page
    self
  end

  def controller type
    type.new self
  end

  def club key, params = nil, create_on_missing: true
    club = @clubs[key]
    if !club && create_on_missing
      club = @clubs[key] = Club.new
    end
    if club && params
      params.each do |k, v|
        club[k] = v
      end
    end
    club
  end

  def theme
    Tgui::Theme.default
  end

  def! :theme do |seed = nil, **na, &b|
    theme = self.theme
    if seed
      theme.reset_attributes
      theme.send! do
        load Tgui::Theme.loadpath(seed)
      end
    end
    theme.send! **na, &b
    theme.self_commit @custom_renderers
  end

  def! :tgui_theme do |path|
    theme = self.theme
    theme.reset_attributes
    theme.source = path
    theme.self_commit @custom_renderers
  end
end