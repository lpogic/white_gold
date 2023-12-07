require_relative 'white_gold/master'
include Tgui

@wg = WhiteGold.new

@wg.methods.difference(Object.instance_methods, [:respond_to?, :method_missing, :go, :[], :page]).each do |m|
  define_method m do |*a, **na, &b|
    @wg.send(m, *a, **na, &b)
  end
end

class << self  

  def respond_to? name
    super || (name.end_with?("!") && @wg.respond_to?(name))
  end

  def method_missing name, *a, **na, &b
    if name.end_with?("!")
      @wg.send(name, *a, **na, &b)
    else super
    end
  end

  def go page
    method(page).unbind.bind(@wg) if Symbol === page && !@wg.respond_to?(page)
    @wg.go page
  end
  
  def page
    @wg.page
  end
end

@wg.init Page
if $0 != 'irb'
  at_exit do
    go :main_page
  rescue NameError
  ensure
    @wg.run init: false
  end
end