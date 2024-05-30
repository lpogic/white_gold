require_relative 'white_gold/master'
require_relative 'white_gold/path/array.path'
include Tgui

@white_gold_instance = WhiteGold.new

class << self 
  include Extree

  def go page
    @white_gold_instance.go page.is_a?(Symbol) ? proc{ send(page) } : page
  end
  
  def page
    @white_gold_instance.page
  end

  def respond_to? name
    super || 
    (name.end_with?("!") && extree_respond_to?(name[...-1])) ||
    @white_gold_instance.page.respond_to?(name)
  end

  def method_missing name, *a, **na, &b
    if name.end_with? "!"
      extree_method_missing name[...-1], *a, **na, &b
    elsif @white_gold_instance.page.respond_to? name
      @white_gold_instance.page.send name, *a, **na, &b
    else super
    end
  end
end
extend Extree::Branch

def! :run do |page = nil|
  go page if page
  @white_gold_instance.run
  @white_gold_instance = nil
end

@white_gold_instance.init window_size: $window_size, window_style: $window_style
@white_gold_instance.load_page Page
if $0 != 'irb'
  at_exit do
    @white_gold_instance&.run
  end
end

Extree::Seed.open_scope self
Extree::Seed.push self