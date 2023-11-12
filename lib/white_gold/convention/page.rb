require_relative "club"

class Page < Tgui::Group

  

  def initialize tgui
    super()
    @tgui = tgui
    @callbacks = {}
    @custom_data = Hash.new do |h, name|
      h[name] = {}
    end
    @clubs = {}
    self.size = [100.pc, 100.pc]

  end

  def inspect
    return "#{object_id}"
  end
  
  def build
  end

  attr :callbacks, :custom_data, :clubs

  def go page
    @tgui.next_page_id = page
  end

  def job **na, &b
    @tgui.job **na, &b
  end

  def timer **na, &b
    @tgui.timer **na, &b
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
end