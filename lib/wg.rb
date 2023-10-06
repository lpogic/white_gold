require_relative 'white_gold'

@gui = Tgui.new

@gui.methods.difference(Object.instance_methods, [:respond_to?, :method_missing, :go]).each do |m|
  define_method m do |*a, **na, &b|
    @gui.send(m, *a, **na, &b)
  end
end

class << self
  def respond_to? name
    super || (name.end_with?("!") && @gui.respond_to?(name))
  end

  def method_missing name, *a, **na, &b
    if name.end_with?("!") && @gui.respond_to?(name)
      @gui.send(name, *a, **na, &b)
    else super
    end
  end

  def go page
    method(page).unbind.bind(@gui) if Symbol === page && !@gui.respond_to?(page)
    @gui.go page
  end
end

@gui.init Page
at_exit do
  go :main_page
rescue NameError
ensure
  @gui.run init: false
end