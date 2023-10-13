class Page < Tgui::Group

  

  def initialize tgui
    super()
    @tgui = tgui
    @callbacks = {}
    @custom_data = Hash.new do |h, name|
      h[name] = {}
    end
    self.size = [100.pc, 100.pc]

  end

  def inspect
    return "#{object_id}"
  end
  
  def build
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
end